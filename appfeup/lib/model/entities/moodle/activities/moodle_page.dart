import 'package:uni/model/entities/moodle/moodle_activity.dart';
import '../../../utils/moodle_activity_type.dart';

class PageActivity extends MoodleActivity {
  List<dynamic> content;

  PageActivity(int id, String title, String description, this.content)
      : super(id, title, MoodleActivityType.page);

}
