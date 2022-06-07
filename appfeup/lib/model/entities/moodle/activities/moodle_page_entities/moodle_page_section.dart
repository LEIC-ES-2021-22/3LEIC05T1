import 'moodle_page_section_title.dart';

/*
  Mapped as a MOODLE_PAGE_CONTENTS in db
 */
class MoodlePageSection {
  final MoodlePageSectionTitle title;
  final List<dynamic> content;

  MoodlePageSection(this.title, this.content);

  Map<String, dynamic> toMap(int order, int pageid){
    return {
      'title': title.text,
      'type': 'moodle_page',
      'orderedby': order,
      'id_page': pageid,
    };
  }

  static MoodlePageSection fromMap(Map<String, dynamic> map){
    return MoodlePageSection(map['title'], null);
  }

  @override
  String toString() {
    return 'CourseInfoSection{title: $title, content: $content}';
  }
}