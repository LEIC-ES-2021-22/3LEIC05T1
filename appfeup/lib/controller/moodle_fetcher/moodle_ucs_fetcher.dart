import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/moodle_uc.dart';
import 'package:uni/model/entities/restaurant.dart';

abstract class MoodleUcsFetcher {
  Future<List<int>> getUcs(Store<AppState> store);
}