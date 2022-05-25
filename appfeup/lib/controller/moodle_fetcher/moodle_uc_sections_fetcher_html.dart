

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/moodle_fetcher/moodle_uc_sections_fetcher.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/model/entities/moodle/section.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/utils/moodle_activity_type.dart';

import '../networking/network_router.dart';

class MoodleUcSectionsFetcherHtml implements MoodleUcSectionsFetcher{
  Future<List<Section>> getSections(CourseUnit uc) async{
    final String url = NetworkRouter.getMoodleUrl()
        + '/course/view.php?id=' + uc.moodleId.toString();

    final Future<Response> response =
      NetworkRouter.federatedGet(url);
    return _getSectionsFromResponse(await response, uc);
  }


  Future<List<Section>> _getSectionsFromResponse(Response response, CourseUnit courseUnit) async{
    final document = parse(response.body);
    final List<Element> sections =
      document.querySelectorAll('.topics > .section');
    return sections.map((sectionElem){
      //Read section info
      String sectionId = sectionElem.attributes['aria-labelledby'].split('-')[1];
      final Element content = sectionElem.querySelector('.content');
      final String title = content.querySelector('h3').text;
      final String summary = content.querySelector('.summary').text;
      final List<Element> activityElements  = content.querySelectorAll('.activity');
      //Read section modules
      final List<MoodleActivity> activities = activityElements.map((element) {
        _getActivityFromElement(element);
      }).toList();

      return  Section(int.parse(sectionId),
          title,
          summary,
          activities: activities,
          courseUnitId: courseUnit.moodleId);
    }).toList();

  }

  MoodleActivity  _getActivityFromElement(Element element){
    MoodleActivityType type;
    for(String elemClass in element.classes){
      type = stringToActivityEnum(elemClass);
      if (type != null){
        break;
      }
    }
    if(type == null){
      return null;
    }
    switch(type){

      case MoodleActivityType.sigarracourseinfo:
        // TODO: Handle this case.
        break;
      case MoodleActivityType.summaries:
        return null;
        break;
      case MoodleActivityType.forum:
        return null;
        break;
      case MoodleActivityType.resource:
        // TODO: Handle this case.
        break;
      case MoodleActivityType.page:
        // TODO: Handle this case.
        break;
      case MoodleActivityType.url:
        // TODO: Handle this case.
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
        // TODO: Handle this case.
        break;
    }
    return null;
  }
}