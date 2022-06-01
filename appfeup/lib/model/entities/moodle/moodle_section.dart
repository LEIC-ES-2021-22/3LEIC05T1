import 'moodle_activity.dart';

class MoodleSection {
  final int id;
  final String title;
  final String summary;
  final int courseUnitId;

  final List<MoodleActivity> activities;

  MoodleSection(this.id, this.title, this.summary,
      {this.activities, this.courseUnitId});

  static MoodleSection fromMap(Map<String, dynamic> map) {
    return MoodleSection(map['id'], map['title'], map['summary']);
  }

  Map<String, dynamic> toMap(int unitCourseId) {
    return {
      'id': id,
      'unit_course_id': unitCourseId,
      'title': title,
      'summary': summary
    };
  }
}
