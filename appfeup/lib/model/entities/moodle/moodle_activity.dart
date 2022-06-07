import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page.dart';
import 'package:uni/model/entities/moodle/activities/moodle_resource.dart';
import 'package:uni/model/entities/moodle/activities/moodle_url.dart';
import 'package:uni/model/utils/moodle_activity_type.dart';

/**
 * Class to represent moodle activities on a MoodleSection.
 * It's almost an abstract class, but allow an moodle activity to be created
 *  without any given type.
*  Should be create using the createFromMap function, as it creates instances
 *  of extended classes
 */
class MoodleActivity {
  final int id;
  final String title;
  final MoodleActivityType type;
  final String description;
  int order;

  MoodleActivity(this.id, this.title, this.type,
      {this.description = '', this.order=-1}
  );

  /**
   * Creates an instance of Moodle activity from a map
   * @param map
   */
  static MoodleActivity fromMap(Map<String, dynamic> map) {
    return MoodleActivity(
      map['id'],
      map['title'],
      stringToActivityEnum(map['type']),
      description: map['description'] ?? '',
      order: map['orderedBy']
    );
  }

  /**
   * Creates an instance of an extended class from MoodleActivity
   * @param map
   */
  static MoodleActivity createFromMap(Map<String, dynamic> map){
    final int id = map['id'];
    final String title = map['title'];
    final String description = map['description'];
    final MoodleActivityType type = stringToActivityEnum(map['type']);
    final int order = map['orderedBy'];

    switch(type){
      case MoodleActivityType.sigarracourseinfo:
        //return SigarraCourseInfo(id, title, );
        break;
      case MoodleActivityType.summaries:
        return null;
        break;
      case MoodleActivityType.forum:
        return null;
        break;
      case MoodleActivityType.resource:
        return MoodleResource.fromMap(map);
        break;
      case MoodleActivityType.page:
        return PageActivity(id, title, description);
        break;
      case MoodleActivityType.url:
        return UrlActivity(id, title,
            map['file_url'],
            order:order,
            description: map['description']
        );
        break;
      case MoodleActivityType.quiz:
        return null;
        break;
      case MoodleActivityType.assign:
        return null;
        break;
      case MoodleActivityType.choicegroup:
        return null;
        break;
      case MoodleActivityType.label:
        //return MoodleActivity(id, title, type);
        break;
    }
    return null;
    //return MoodleActivity(id, title, type);
  }

  /**
   * Converts an activity to match the database
   */
  Map<String, dynamic> toMap(int sectionId) {
    return {
      'id': id,
      'section_id': sectionId,
      'title': title,
      'type': type.name,
      'description': description,
      'file_url': '',
      'file_path': '',
      'orderedBy': order
    };
  }
}
