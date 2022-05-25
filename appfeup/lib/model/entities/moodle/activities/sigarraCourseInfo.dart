import 'package:uni/model/entities/moodle/activities/activity.dart';

class SigarraCourseInfo extends Activity
{
  String title;
  Map<String, String> content;


  SigarraCourseInfo(String name, String title, Map<String, String> content):super(name)
  {
    this.title = title;
    this.content = content;
  }

  String getTitle()
  {
    return title;
  }

  Map<String, String> getContent()
  {
    return this.content;
  }
}