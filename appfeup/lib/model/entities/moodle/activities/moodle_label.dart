import 'package:uni/model/entities/moodle/moodle_activity.dart';
import '../../../utils/moodle_activity_type.dart';

class LabelActivity extends MoodleActivity {
  LabelActivity(int id, String text, {
    int order = 0
  })
      : super(id, text, MoodleActivityType.label, order: order);

  Map<String, dynamic> toMap(int sectionId) {
    return super.toMap(sectionId);
  }
}
