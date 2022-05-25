import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_section.dart';
import 'package:uni/model/entities/session.dart';

abstract class MoodleUcSectionsFetcher {
  Future<List<Section>> getSections(MoodleCourseUnit uc);
}