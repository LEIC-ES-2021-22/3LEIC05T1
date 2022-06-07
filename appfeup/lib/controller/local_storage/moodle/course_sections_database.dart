import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/model/entities/moodle/activities/moodle_resource.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/model/entities/moodle/moodle_section.dart';

import '../app_database.dart';

/**
 * Relative to moodle
 */
class CourseSectionsDatabase extends AppDatabase {
  static final String _TABLENAME = 'course_sections';

  CourseSectionsDatabase()
      : super(_TABLENAME + '.db', [
          ''' CREATE TABLE COURSE_SECTIONS(
      id INTEGER PRIMARY KEY,
      unit_course_id INTEGER,
      title TEXT,
      summary TEXT,
      orderedBy INTEGER
    )
    ''',
          ''' CREATE TABLE SECTION_MODULES(
        id INTEGER PRIMARY KEY,
        section_id INTEGER,
        title TEXT,
        type TEXT,
        orderedBy INTEGER,
        description TEXT,
        file_path TEXT,
        file_url TEXT
        )
    '''
        ]);

  Future<List<MoodleSection>> getSections(int ucId) async {
    try {
      final Database db = await getDatabase();

      final List<dynamic> list = await db.query('COURSE_SECTIONS',
          where: 'unit_course_id = ?', whereArgs: [ucId],
          orderBy: 'orderedBy asc');
      Logger().i('list = ' + list.length.toString());
      List<MoodleSection> sections =
        list.map((map) => MoodleSection.fromMap(map)).toList();
      Logger().i('sections size = ' + sections.length.toString());
      for(MoodleSection section in sections){
        section.activities = await getActivities(db, section.id);
      }

      return sections;
    } catch(e, s){
      Logger().e('get sections error =  ' + s.toString());
    }
    return null;
  }

  Future<List<MoodleResource>> getActivities(Database db, int sectionId) async{
    final List<dynamic> list = await db.query('SECTION_MODULES',
        where: 'section_id = ? ', whereArgs: [sectionId],
        orderBy: 'orderedBy asc');
    return list.map((map) => MoodleActivity.createFromMap(map)).toList();
  }

  Future<void> saveSections(List<MoodleSection> sections,
      {int courseId = -1}) async {
    Logger().i('sections ' + sections.length.toString());
    final Database db = await getDatabase();
    db.transaction((txn) async{
      try {
        //final Batch batch = txn.batch();
        for (MoodleSection section in sections) {
          await txn.delete('SECTION_MODULES', where: 'section_id = ?',
              whereArgs: [section.id]);
          await txn.delete(
              _TABLENAME, where: 'id = ?', whereArgs: [section.id]);
          Logger().i('save section ' + section.toMap(courseId).toString());
          txn.insert(_TABLENAME, section.toMap(courseId));
          saveActivities(section.activities, section.id, txn);
        }

      } catch(e, s){
        Logger().e('erro save sections ' + s.toString());
      }
    });


  }

  Future<void> saveActivities(
    List<MoodleActivity> activities, int sectionId, Transaction txn) async {
    try {
      for (MoodleActivity module in activities) {
        Logger().i('activity = ' + module.toMap(sectionId).toString());
        txn.insert('SECTION_MODULES', module.toMap(sectionId));
      }
    } catch(e, s){
      Logger().e('saveactivityerror ' + s.toString());
    }

  }

  Future<void> saveResourcePath(MoodleResource resource, String path) async{
    final Database db = await getDatabase();
    db.rawQuery
      ('update section_modules set file_path = ? where id = ?',
       [path, resource.id]);
  }
  Future<List<MoodleSection>> getModules(int sectionId) async {
    final Database db = await getDatabase();

    final List<dynamic> list = await db.query('section_modules',
        where: 'section_id = ?', whereArgs: [sectionId]);
    return list.map((map) => MoodleSection.fromMap(map)).toList();
  }
}
