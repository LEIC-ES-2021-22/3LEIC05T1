import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:redux/redux.dart';
import 'package:uni/controller/local_storage/image_offline_storage.dart';
import 'package:uni/controller/local_storage/moodle/course_units_database.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/redux/refresh_items_action.dart';

import '../model/entities/moodle/activities/moodle_resource.dart';
import '../model/entities/session.dart';
import 'local_storage/app_shared_preferences.dart';
import 'local_storage/moodle/course_sections_database.dart';

Future loadReloginInfo(Store<AppState> store) async {
  final Tuple2<String, String> userPersistentCredentials =
      await AppSharedPreferences.getPersistentUserInfo();
  final List<String> userPersistentFacs =
      await AppSharedPreferences.getUserFaculties();
  final String userName = userPersistentCredentials.item1;
  final String password = userPersistentCredentials.item2;
  final List<String> faculties =
      userPersistentFacs.isEmpty ? userPersistentFacs : ['feup'];

  if (userName != '' && password != '') {
    final action = Completer();

    /// TODO: support for multiple faculties. Issue: #445
    store.dispatch(reLogin(userName, password, faculties[0], action: action));

    return action.future;
  }
  return Future.error('No credentials stored');
}

Future loadUserInfoToState(store) async {
  loadLocalUserInfoToState(store);
  if (await (Connectivity().checkConnectivity()) != ConnectionState.none) {
    return loadRemoteUserInfoToState(store);
  }
}

Future loadRemoteUserInfoToState(Store<AppState> store) async {
  if (store.state.content['session'] == null) {
    return null;
  } else if (!store.state.content['session'].authenticated &&
      store.state.content['session'].persistentSession) {
    await loadReloginInfo(store);
  }

  final Completer<Null> userInfo = Completer(),
      exams = Completer(),
      schedule = Completer(),
      printBalance = Completer(),
      fees = Completer(),
      coursesStates = Completer(),
      trips = Completer(),
      lastUpdate = Completer(),
      restaurants = Completer(),
      moodleSections = Completer();

  store.dispatch(getUserInfo(userInfo));
  store.dispatch(getUserPrintBalance(printBalance));
  store.dispatch(getUserFees(fees));
  store.dispatch(getUserCoursesState(coursesStates));
  store.dispatch(getUserBusTrips(trips));
  store.dispatch(getRestaurantsFromFetcher(restaurants));

  final Tuple2<String, String> userPersistentInfo =
      await AppSharedPreferences.getPersistentUserInfo();
  userInfo.future.then((value) {
    store.dispatch(getUserExams(exams, ParserExams(), userPersistentInfo));
    store.dispatch(getUserSchedule(schedule, userPersistentInfo));
    store.dispatch(getAllMoodleContentsFromFetcher(moodleSections));
  });

  final allRequests = Future.wait([
    exams.future,
    schedule.future,
    printBalance.future,
    fees.future,
    coursesStates.future,
    userInfo.future,
    trips.future,
    restaurants.future,
    moodleSections.future
  ]);
  allRequests.then((futures) {
    store.dispatch(setLastUserInfoUpdateTimestamp(lastUpdate));
  });
  return lastUpdate.future;
}

void loadLocalUserInfoToState(store) async {
  Logger().i('Loading localUserInfo');
  store.dispatch(
      UpdateFavoriteCards(await AppSharedPreferences.getFavoriteCards()));
  store.dispatch(SetExamFilter(await AppSharedPreferences.getFilteredExams()));
  store.dispatch(
      SetUserFaculties(await AppSharedPreferences.getUserFaculties()));
  final Tuple2<String, String> userPersistentInfo =
      await AppSharedPreferences.getPersistentUserInfo();
  if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
    store.dispatch(updateStateBasedOnLocalProfile());
    store.dispatch(updateStateBasedOnLocalCourseUnits());
    store.dispatch(updateStateBasedOnLocalUserExams());
    store.dispatch(updateStateBasedOnLocalUserLectures());
    store.dispatch(updateStateBasedOnLocalUserBusStops());
    store.dispatch(updateStateBasedOnLocalMoodleContents());
    store.dispatch(updateStateBasedOnLocalRefreshTimes());
    store.dispatch(updateStateBasedOnLocalTime());
    store.dispatch(SaveProfileStatusAction(RequestStatus.successful));
    store.dispatch(SetPrintBalanceStatusAction(RequestStatus.successful));
    store.dispatch(SetFeesStatusAction(RequestStatus.successful));
    store.dispatch(SetCoursesStatesStatusAction(RequestStatus.successful));
  }
}

Future<void> handleRefresh(store) {
  final action = RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
}

Future<File> loadProfilePic(Store<AppState> store) {
  final String studentNo = store.state.content['session'].studentNumber;
  String url =
      'https://sigarra.up.pt/feup/pt/fotografias_service.foto?pct_cod=';
  final Map<String, String> headers = Map<String, String>();

  if (studentNo != null) {
    url += studentNo;
    headers['cookie'] = store.state.content['session'].cookies;
  }
  return retrieveImage(url, headers);
}

/**
 * Checks if device already has the file. If not, download it
 */
Future<String> getMoodleResource(Session session, MoodleResource resource) async{
  print('filepath = ' + resource.filePath.toString());
  final String path = (await getApplicationDocumentsDirectory()).path;
  String filePath;

  if(resource.filePath != null && resource.filePath != ''){
    filePath = resource.filePath;
  } else {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      final hasInternetConnection = connectivityResult !=
          ConnectivityResult.none;
      if (!hasInternetConnection) {
        return null;
      }
      await NetworkRouter.loginMoodle(session);
      Logger().i('starting request');
      Response response = await NetworkRouter.federatedGet(resource.fileURL);

      String extension = '.' +
          response.request.url.toString().split('.')[1];


      final File file = File(path + resource.id.toString() + extension);
      RandomAccessFile raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.bodyBytes);
      await raf.close();
      filePath = file.path;

      //Save resource
      final CourseSectionsDatabase db = CourseSectionsDatabase();
      db.saveResourcePath(resource, filePath);
      resource.filePath = filePath;
    } catch(e, s){
      Logger().e(s);
    }
  }
  return filePath;
}
