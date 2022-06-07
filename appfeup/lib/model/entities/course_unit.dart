import 'package:uni/utils/constants.dart';

/// Stores information about a course unit.
class CourseUnit {
  int id;
  String code;
  String abbreviation;
  String name;
  int curricularYear;
  int occurrId;
  String semesterCode;
  String semesterName;
  String type;
  String status;
  String grade;
  String ectsGrade;
  String result;
  num ects;
  bool hasMoodle;
  int moodleId;
  int order;

  CourseUnit({this.id,
  this.code,
  this.abbreviation,
  this.name,
  this.curricularYear,
  this.occurrId,
  this.semesterCode,
  this.semesterName,
  this.type,
  this.status,
  this.grade,
  this.ectsGrade,
  this.result,
  this.ects,
  this.hasMoodle,
  this.moodleId,
  this.order});

  /// Creates a new instance from a JSON object.
  static CourseUnit fromJson(dynamic data,
  {bool hasMoodle = false,
    moodleId = -1,
    order  = 0
  }) {
    return CourseUnit(
      id: data['ucurr_id'],
      code: data['ucurr_codigo'],
      abbreviation: data['ucurr_sigla'],
      name: data['ucurr_nome'],
      curricularYear: data['ano'],
      occurrId: data['ocorr_id'],
      semesterCode: data['per_codigo'],
      semesterName: data['per_nome'],
      type: data['tipo'],
      status: data['estado'],
      grade: data['resultado_melhor'],
      ectsGrade: data['resultado_ects'],
      result: data['resultado_insc'],
      ects: data['creditos_ects'],
      hasMoodle: hasMoodle,
      moodleId: moodleId,
      order: order,
    );
  }

  static CourseUnit fromMap(Map<String, dynamic> map){
    return CourseUnit(
      id: map['id'],
      code: map['code'],
      abbreviation: map['abbreviation'],
      name: map['name'],
      curricularYear: map['curricular_year'],
      occurrId: map['occur_id'],
      semesterCode: map['semester_code'],
      semesterName: map['semester_name'],
      type: map['type'],
      status: map['status'],
      grade: map['grade'],
      ectsGrade: map['ects_grade'],
      result: map['result'],
      ects: map['ects'],
      hasMoodle: map['has_moodle'] == 1,
      moodleId: map['moodle_id']
    );
  }

  Map<String, dynamic> toMap({toMoodle = false}){
    if(toMoodle) {
      return {
        'id': moodleId,
        'designation': name,
        'has_moodle': hasMoodle ? 1 : 0,
        'orderedBy': order
      };
    }
    return {
      'occur_id': occurrId,
      'id': id,
      'code': code,
      'abbreviation': abbreviation,
      'name': name,
      'curricular_year': curricularYear,
      'semester_code': semesterCode,
      'semester_name': semesterName,
      'type': type,
      'status': status,
      'grade': grade,
      'ects_grade': ectsGrade,
      'result': result,
      'ects': ects,
      'has_moodle': hasMoodle ? 1 : 0,
      'moodle_id': moodleId
    };
  }

}