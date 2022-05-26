import 'package:uni/model/entities/moodle/moodle_section.dart';

class MoodleCourseUnit{
  final int id;
  final String shortName;
  final String fullName;

  List<MoodleSection> sections;

  MoodleCourseUnit(this.id, {this.shortName, this.fullName, this.sections});

  static MoodleCourseUnit fromMap(Map<String, dynamic> map){
    return MoodleCourseUnit(
        map['id'],
        fullName : map['fullname'],
        shortName : map['shortname']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'fullName' : fullName,
      'shortName' : shortName
    };
  }
}