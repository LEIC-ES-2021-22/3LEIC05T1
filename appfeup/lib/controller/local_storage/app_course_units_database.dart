

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
          moodle_id INTEGER,
          orderedBy INTEGER
        )
    ''']);

  void saveCourseUnits(List<CourseUnit> courseUnits) async{
    final Database db = await getDatabase();
    final Batch batch = db.batch();
    int order = 0;
    for(CourseUnit unit in courseUnits){
      _saveCourseUnit(unit, batch, order++);
    }
    batch.commit(noResult: true);
    db.close();
  }

  void _saveCourseUnit(CourseUnit unit, Batch batch, int order){
    batch.insert(_TABLENAME, unit.toMap(orderedBy: order));
  }

  Future<List<CourseUnit>> getCourseUnits() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> coursesMap =
      await db.query(_TABLENAME, orderBy: 'orderedBy asc');
    return coursesMap.map( (map){
      return CourseUnit.fromMap(map);
      }
    ).toList();
  }

}
