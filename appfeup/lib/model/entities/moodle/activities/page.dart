import 'package:uni/model/entities/moodle/activities/activity.dart';

class PageActivity extends Activity
{
  String title;
  List<String> content;


  PageActivity(String name, String title, List<String> content):super(name)
  {
    this.title = title;
    this.content = content;
  }

  String getTitle()
  {
    return title;
  }

  List<String> getContent()
  {
    return this.content;
  }
}