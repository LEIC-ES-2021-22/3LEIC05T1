import 'moodle_course_info_title.dart';

class CourseInfoSection {
  final CourseInfoTitle title;
  final List<dynamic> content;

  CourseInfoSection(this.title, this.content);

  @override
  String toString() {
    return 'CourseInfoSection{title: $title, content: $content}';
  }
}