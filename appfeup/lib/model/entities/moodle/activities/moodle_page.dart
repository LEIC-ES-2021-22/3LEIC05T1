import 'package:uni/model/entities/moodle/moodle_activity.dart';
import '../../../utils/moodle_activity_type.dart';

class PageActivity extends MoodleActivity {
  PageActivity(int id, String title, String description)
      : super(id, title, MoodleActivityType.page, description: description);
}
