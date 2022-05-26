

import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/course_unit.dart';

class CourseUnitsDatabase extends AppDatabase {
  static final String _TABLENAME = 'ucs';

  CourseUnitsDatabase(): super(_TABLENAME + '.db',
      [''' CREATE TABLE $_TABLENAME(
          occur_id INTEGER PRIMARY KEY,
          id INTEGER,
          code TEXT,
          abbreviation TEXT,
          name TEXT NOT NULL UNIQUE,
          curricular_year INTEGER,
          semester_code TEXT,
          semester_name TEXT,
          type TEXT,
          status TEXT,
          ects_grade TEXT,
          ects INTEGER,
          grade TEXT,
          result TEXT,
          has_moodle INTEGER,
          moodle_id INTEGER
        )
    ''']);

  void saveCourseUnits(List<CourseUnit> courseUnits) async{
    Logger().i('Saving course units' + courseUnits.length.toString());
    final Database db = await getDatabase();
    final Batch batch = db.batch();
    for(CourseUnit unit in courseUnits){
      _saveCourseUnit(unit, batch);
    }
    batch.commit(noResult: true);
    Logger().i('Done saving course units');
    final List<Map<String, dynamic>> coursesMap = await db.query(_TABLENAME);
    Logger().i('CoursesMap.length after inserting = ' + coursesMap.length.toString());
    db.close();
  }

  void _saveCourseUnit(CourseUnit unit, Batch batch){
    batch.insert(_TABLENAME, unit.toMap());
  }

  Future<List<CourseUnit>> getCourseUnits() async{
    final Database db = await getDatabase();
    Logger().i('ola');
    final List<Map<String, dynamic>> coursesMap = await db.query(_TABLENAME);
    Logger().i('CoursesMap.length = ' + coursesMap.length.toString());
    return coursesMap.map( (map){
      Logger().i('ola' + map['id'].toString());
      return CourseUnit.fromMap(map);
      }
    ).toList();
  }

}
