import 'package:uni/model/utils/moodle_activity_type.dart';

class MoodleActivity {
  final int id;
  final String title;
  final MoodleActivityType type;
  final String description;

  MoodleActivity(this.id, this.title, this.type, {this.description = ''});

  static MoodleActivity fromMap(Map<String, dynamic> map) {
    return MoodleActivity(
      map['id'],
      map['title'],
      map['type'],
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap(int sectionId) {
    return {
      'id': id,
      'section_id': sectionId,
      'title': title,
      'type': type,
      'description': description
    };
  }
}
