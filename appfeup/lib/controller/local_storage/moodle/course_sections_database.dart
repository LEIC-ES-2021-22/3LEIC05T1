import 'package:sqflite/sqflite.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/model/entities/moodle/section.dart';

import '../app_database.dart';

class CourseSectionsDatabase extends AppDatabase{
    static final  String _TABLENAME = 'course_sections';

    CourseSectionsDatabase(): super(_TABLENAME + '.db',
    [''' CREATE TABLE COURSE_SECTIONS(
      id INTEGER PRIMARY KEY,
      unit_course_id,
      title text,
      summary text
    )
    ''',
    ''' CREATE TABLE SECTION_MODULES(
        id INTERGER PRIMARY KEY,
        section_id INTEGER,
        title TEXT,
        type TEXT,
        description TEXT
        )
    ''']);

    Future<List<Section>> getSections(int ucId) async{
        final Database db = await getDatabase();

        final List<dynamic> list = await
            db.query('course_sections',
                where: 'unit_course_id = ?',
                whereArgs: [ucId]);
        return list.map((map) => Section.fromMap(map)).toList();
    }

    Future<void> saveSections(List<Section> sections, {int courseId = -1}) async{
        final Database db = await getDatabase();
        final Batch batch = db.batch();

        for(Section section in sections){
            batch.insert(_TABLENAME, section.toMap(courseId));
        }
        batch.commit(noResult: true);
    }

    Future<void> saveActivities(List<MoodleActivity> activities, int sectionId) async{
        final Database db = await getDatabase();
        final Batch batch = db.batch();

        for(MoodleActivity module in activities){
            batch.insert('section_modules', module.toMap(sectionId));
        }
        batch.commit(noResult: true);
    }

    Future<List<Section>> getModules(int sectionId) async{
        final Database db = await getDatabase();

        final List<dynamic> list = await
        db.query('section_modules',
            where: 'section_id = ?',
            whereArgs: [sectionId]);
        return list.map((map) => Section.fromMap(map)).toList();
    }

}