import 'package:logger/logger.dart';

import 'moodle_activity.dart';

class MoodleSection {
  final int id;
  final String title;
  final String summary;
  final int courseUnitId;
  final int order;
  List<MoodleActivity> activities;

  MoodleSection(this.id, this.title, this.summary,
      {this.activities, this.courseUnitId,
      this.order});

  static MoodleSection fromMap(Map<String, dynamic> map) {
    Logger().i('map = ' + map.toString());
    return MoodleSection(map['id'], map['title'], map['summary'], order: map['orderedBy']);
  }

  Map<String, dynamic> toMap(int unitCourseId) {
    return {
      'id': id,
      'unit_course_id': unitCourseId,
      'title': title,
      'summary': summary,
      'orderedBy': order
    };
  }
}
