

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/Moodle/moodle_activity.dart';
import 'package:uni/model/entities/Moodle/section.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/utils/moodle_activity_type.dart';

import '../networking/network_router.dart';

abstract class MoodleUcSectionsFetcher {
  Future<List<Section>> getSections(Session session, CourseUnit uc) async{
    final String url = NetworkRouter.getMoodleUrl()
        + '/course/view.php?id=' + uc.id.toString();

    final Future<Response> response =
      NetworkRouter.getWithCookies(url,{}, session);
    return _getSectionsFromResponse(await response);
  }


  Future<List<Section>> _getSectionsFromResponse(Response response) async{
    final document = parse(response.body);
    final List<Element> sections =
      document.querySelectorAll('.topics > .section');

    return sections.map((sectionElem){
      //Read section info
      String sectionId = sectionElem.attributes['aria-labeledby'].split('-')[1];
      final Element content = sectionElem.querySelector('.content');
      final String title = content.querySelector('h3').text;
      final String summary = content.querySelector('.summary').text;
      final List<Element> moduleElements  = content.querySelectorAll('.activity');

      //Read section modules
      final List<MoodleActivity> modules = moduleElements.map((element) {
        _getModuleFromElement(element);
      }).toList();

      return  Section(int.parse(sectionId), title, summary, activities: modules);
    }).toList();

  }

  MoodleActivity  _getModuleFromElement(Element element){
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