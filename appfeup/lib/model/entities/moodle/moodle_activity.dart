import 'package:uni/model/utils/moodle_activity_type.dart';

class MoodleActivity {
  final int id;
  final String title;
  final MoodleActivityType type;
  final String description;
  int order;

  MoodleActivity(this.id, this.title, this.type,
      {this.description = '', this.order=-1}
  );

  static MoodleActivity fromMap(Map<String, dynamic> map) {
    return MoodleActivity(
      map['id'],
      map['title'],
      stringToActivityEnum(map['type']),
      description: map['description'] ?? '',
      order: map['orderedBy']
    );
  }

  Map<String, dynamic> toMap(int sectionId) {
    return {
      'id': id,
      'section_id': sectionId,
      'title': title,
      'type': type.name,
      'description': description,
      'file_url': '',
      'file_path': '',
      'orderedBy': order
    };
  }
}
