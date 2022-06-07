import 'package:uni/model/entities/moodle/moodle_section.dart';

class MoodleCourseUnit{
  final int id;
  final String shortName;
  final String fullName;
  final int order;
  List<MoodleSection> sections;

  MoodleCourseUnit(this.id, {this.shortName, this.fullName, this.sections, this.order});

  static MoodleCourseUnit fromMap(Map<String, dynamic> map){
    return MoodleCourseUnit(
        map['id'],
        fullName : map['fullname'],
        shortName : map['shortname'],
        order: map['orderedBy']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'fullName' : fullName,
      'shortName' : shortName,
      'order': order
    };
  }
}