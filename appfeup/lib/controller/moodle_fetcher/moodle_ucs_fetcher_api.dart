import 'dart:convert';

import 'package:http/http.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_restaurants.dart';
import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/moodle_uc.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'moodle_ucs_fetcher.dart';

/// Class for fetching the user's lectures from the schedule's HTML page.
class MoodleUcsFetcherAPI extends MoodleUcsFetcher {
  /// Fetches the user's lectures from the schedule's HTML page.
  @override
  Future<List<int>> getUcs(Store<AppState> store) async {
    Session session = store.state.content['session'];
    final String baseUrl = NetworkRouter.getMoodleUrl() +
        '/lib/ajax/service.php?sesskey='
    + session.moodleSessionKey
    + '&info=core_course_get_enrolled_courses_by_timeline_classification';

    //Change to customfield to filter by semester
    final Map<String, String> body = {
      'classification' : 'allincludinghidden', //allincludinghidden to show all
      'sort' : 'shortname',
      'customfieldname' : 'periodo',
      'customfieldvalue' : '2'
    };



    final Future<Response> response =
    NetworkRouter.postWithCookies(baseUrl, session, body);


    return getUcsFromResponse(await response);
  }


  Future<List<int>> getUcsFromResponse (Response response) async{
    final json = jsonDecode(response.body);
    final responseJson = json['response'];
    if(responseJson['error'].toBoolean()){
      //Throw error
    } else {
      final List<dynamic> courses = responseJson['data']['courses'];
      return courses.map(
              (course) => int.parse(course['id'])
      ).toList();

    }
  }
}
