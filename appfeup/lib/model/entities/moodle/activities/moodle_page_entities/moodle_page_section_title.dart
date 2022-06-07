/*
  Mapped as a MOODLE_PAGE_CONTENT_OBJECT in db
 */
class MoodlePageSectionTitle {
  final String text;
  final int headingNr;

  MoodlePageSectionTitle(this.text, this.headingNr);

  Map<String, dynamic> toMap(int sectionId, int order){
    return {
      'id_content': sectionId,
      'orderedby': order,
      'type': 'title',
      'title': text,
      'heading_nr': headingNr
    };
  }

  @override
  String toString() {
    return 'CourseInfoTitle{text: $text}';
  }



}
