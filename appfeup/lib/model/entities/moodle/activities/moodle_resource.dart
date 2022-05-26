import '../../../utils/moodle_activity_type.dart';
import '../../Moodle/moodle_activity.dart';

class MoodleResource extends MoodleActivity {
  final String filePath;
  final String fileURL;

  MoodleResource(int id, String title, MoodleActivityType type,
      {this.filePath, this.fileURL})
      : super(id, title, type);
}
