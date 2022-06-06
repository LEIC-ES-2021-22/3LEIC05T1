import 'package:uni/model/entities/moodle/moodle_activity.dart';
import '../../../utils/moodle_activity_type.dart';

class UrlActivity extends MoodleActivity {
  final String url;
  UrlActivity(int id, String title, String this.url)
      : super(id, title, MoodleActivityType.url);

  Map<String, dynamic> toMap(int sectionId) {
    final Map<String, dynamic> map = {
      'file_url': url
    };
    map.addAll(super.toMap(sectionId));
    return map;
  }
}
