import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/model/utils/moodle_activity_type.dart';

class SigarraCourseInfo extends MoodleActivity {
  final Map<String, String> content;

  SigarraCourseInfo(int id, String title, Map<String, String> this.content)
      : super(id, title, MoodleActivityType.sigarracourseinfo.name);


}
