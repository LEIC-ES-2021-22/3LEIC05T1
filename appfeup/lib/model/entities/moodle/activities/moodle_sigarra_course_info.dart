import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/model/utils/moodle_activity_type.dart';

class SigarraCourseInfo extends MoodleActivity {

  //List has multiple moodle_page_section
  final List<dynamic> content;

  SigarraCourseInfo(
      int id, String title, List<dynamic> this.content)
      : super(id, title, MoodleActivityType.sigarracourseinfo);
}
