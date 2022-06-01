import '../../../utils/moodle_activity_type.dart';
import '../../Moodle/moodle_activity.dart';

class MoodleResource extends MoodleActivity {
  final String filePath;
  final String fileURL;

  MoodleResource(int id, String title,
      {this.filePath, this.fileURL})
      : super(id, title, MoodleActivityType.resource.name);

  Map<String, dynamic> toMap(int sectionId) {
    return {
      'id': id,
      'section_id': sectionId,
      'title': title,
      'type': type,
      'description': description,
      'file_path': filePath,
      'file_url': fileURL
    };
  }

  static MoodleResource fromMap(Map<String, dynamic> map) {
    return MoodleResource(
      map['id'],
      map['title'],
      map['type'],
      filePath: map['file_path'],
      fileURL: map['file_url']

    );
  }
}
