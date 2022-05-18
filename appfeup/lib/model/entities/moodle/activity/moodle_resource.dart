import 'package:uni/model/entities/Moodle/moodle_activity.dart';

class MoodleResource extends MoodleActivity{
  final String filePath;
  final String fileURL;
  MoodleResource(
      int id,
      String title,
      String type,
      {this.filePath, this.fileURL})
      : super(id, title, type);

}