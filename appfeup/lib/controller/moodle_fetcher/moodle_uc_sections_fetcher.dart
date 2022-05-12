import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/section.dart';

abstract class MoodleUcSectionsFetcher {
  Future<List<Section>> getSections(Store<AppState> store, CourseUnit uc);
}