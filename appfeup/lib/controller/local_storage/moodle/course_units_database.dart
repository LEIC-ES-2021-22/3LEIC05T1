import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/moodle/course_sections_database.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/model/entities/moodle/section.dart';

import '../app_database.dart';

class MoodleCourseUnitsDatabase extends AppDatabase{

    static final  String _TABLENAME = 'course_units';
    MoodleCourseUnitsDatabase(): super(_TABLENAME + '.db',
    [''' CREATE TABLE $_TABLENAME (
      id INTEGER PRIMARY KEY,
      designation TEXT,
      has_moodle INTEGER
    )
    ''']);

    void saveCourseUnits(List<CourseUnit> courseUnits) async{
        Logger().i('Save moodle course units' + courseUnits.length.toString());
        final Database db = await getDatabase();
        db.delete(_TABLENAME);
        for(CourseUnit unit in courseUnits){
            await db.insert(_TABLENAME, unit.toMap(toMoodle: true));
            //_saveCourseUnit(unit, batch);
        }
        //batch.commit(noResult: false);
        final List<Map<String, dynamic>> coursesMap =
            await db.query(_TABLENAME);
        Logger().i('Save moodle course end' + coursesMap.length.toString());
    }

    void _saveCourseUnit(CourseUnit unit, Batch batch){
        batch.insert(_TABLENAME, unit.toMap(toMoodle: true));
    }

    Future<List<MoodleCourseUnit>> getCourseUnits() async {
        final Database db = await getDatabase();
        final CourseSectionsDatabase sectionsDatabase= CourseSectionsDatabase();
        Logger().i('Start begin getmoodle');
        List<Map<String, dynamic>> coursesMap =
            await db.query(_TABLENAME, where: 'has_moodle = 1 ' );
        Logger().i('Foste aqui ' + coursesMap.length.toString());
        final List<MoodleCourseUnit> courseUnits = [];
        for(Map<String, dynamic> map in coursesMap){
            Logger().i('Foste aqui 1');
            final int id = map['id'];
            Logger().i('Foste aqui 2' );
            final List<Section> sections =
                await sectionsDatabase.getSections(id);
            Logger().i('Foste aqui 3');
            courseUnits.add(MoodleCourseUnit(id, fullName: map['designation'], sections: sections));
        }
        Logger().i('Start begin getmoodle');
        return courseUnits;
    }
}