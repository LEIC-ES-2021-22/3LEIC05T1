import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/model/entities/session.dart';



abstract class MoodleUcsFetcher {
  Future<List<MoodleCourseUnit>> getUcs(Session session);
}