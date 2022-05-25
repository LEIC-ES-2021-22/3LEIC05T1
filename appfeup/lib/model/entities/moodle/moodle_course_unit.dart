import 'package:uni/model/entities/moodle/section.dart';

class MoodleCourseUnit{
  final int id;
  final String shortName;
  final String fullName;

  List<Section> sections;

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