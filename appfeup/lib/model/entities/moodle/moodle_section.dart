import 'moodle_activity.dart';

class Section {
  final int id;
  final String title;
  final String summary;
  final int courseUnitId;

  final List<MoodleActivity> activities;

  Section(this.id, this.title, this.summary,
      {this.activities, this.courseUnitId});

  static Section fromMap(Map<String, dynamic> map) {
    return Section(map['id'], map['title'], map['summary']);
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
