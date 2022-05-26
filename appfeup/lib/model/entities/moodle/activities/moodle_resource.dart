import '../../../utils/moodle_activity_type.dart';
import '../../Moodle/moodle_activity.dart';

class MoodleResource extends MoodleActivity {
  final String filePath;
  final String fileURL;

  MoodleResource(int id, String title,
      {this.filePath, this.fileURL})
      : super(id, title, MoodleActivityType.resource.name);
}
