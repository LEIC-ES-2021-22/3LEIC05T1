import 'package:sqflite/sqflite.dart';
import 'package:uni/model/entities/course_unit.dart';

import '../app_database.dart';

class CourseUnitsDatabase extends AppDatabase{

    static final  String _TABLENAME = 'course_units';
    CourseUnitsDatabase(): super(_TABLENAME + '.db',
    [''' CREATE TABLE COURSE_UNITS(
      id INTEGER PRIMARY KEY,
      designation TEXT,
      has_moodle INTEGER
    )
    ''']);

    void saveCourseUnits(List<CourseUnit> courseUnits) async{
        final Database db = await getDatabase();
        final Batch batch = db.batch();
        for(CourseUnit unit in courseUnits){
            _saveCourseUnit(unit, batch);
        }
        batch.commit(noResult: true);
    }

    void _saveCourseUnit(CourseUnit unit, Batch batch){
        batch.insert(_TABLENAME, unit.toMap());
    }
}