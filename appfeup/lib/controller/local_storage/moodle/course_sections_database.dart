import '../app_database.dart';

class CourseSectionsDatabase extends AppDatabase{
    CourseSectionsDatabase(): super('course_sections.db',
    [''' CREATE TABLE COURSE_SECTIONS(
      id INTEGER,
      course_id,
      PRIMARY KEY(id, course_id),
      title text,
      summary
    )
    ''']);



}