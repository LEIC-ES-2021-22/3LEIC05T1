import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/moodle/course_sections_database.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_section.dart';

import '../app_database.dart';

class MoodleCourseUnitsDatabase extends AppDatabase{

    static final  String _TABLENAME = 'course_units';
    MoodleCourseUnitsDatabase(): super(_TABLENAME + '.db',
    [''' CREATE TABLE $_TABLENAME (
      id INTEGER PRIMARY KEY,
      designation TEXT,
      has_moodle INTEGER,
      orderedBy INTEGER
    )
    ''']);

    void saveCourseUnits(List<CourseUnit> courseUnits) async{
        final Database db = await getDatabase();
        await db.delete(_TABLENAME);
        for(CourseUnit unit in courseUnits){
            if(unit.hasMoodle) {
                await db.insert(_TABLENAME, unit.toMap(toMoodle: true));
            }
            //_saveCourseUnit(unit, batch);
        }
        //batch.commit(noResult: false);
    }

    void _saveCourseUnit(CourseUnit unit, Batch batch){
        batch.insert(_TABLENAME, unit.toMap(toMoodle: true));
    }

    Future<List<MoodleCourseUnit>> getCourseUnits() async {
        final Database db = await getDatabase();
        final CourseSectionsDatabase sectionsDatabase= CourseSectionsDatabase();
        List<Map<String, dynamic>> coursesMap =
            await db.query(_TABLENAME,
            orderBy: 'orderedBy asc ');
        final List<MoodleCourseUnit> courseUnits = [];
        for(Map<String, dynamic> map in coursesMap){
            final int id = map['id'];
            final List<MoodleSection> sections =
                await sectionsDatabase.getSections(id);
            Logger().i('sections = ' + sections.length.toString());
            courseUnits.add(MoodleCourseUnit(id, fullName: map['designation'], sections: sections));
        }
        return courseUnits;
    }
}