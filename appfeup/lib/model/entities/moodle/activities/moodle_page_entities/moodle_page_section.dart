import 'moodle_page_section_title.dart';

class MoodlePageSection {
  final MoodlePageSectionTitle title;
  final List<dynamic> content;

  MoodlePageSection(this.title, this.content);

  @override
  String toString() {
    return 'CourseInfoSection{title: $title, content: $content}';
  }
}