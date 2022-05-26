import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/moodle_fetcher/moodle_uc_sections_fetcher.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/activities/moodle_sigarra_course_info.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_section.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/utils/moodle_activity_type.dart';

import '../../model/entities/moodle/activities/moodle_page.dart';
import '../networking/network_router.dart';

class MoodleUcSectionsFetcherHtml implements MoodleUcSectionsFetcher {
  Future<List<MoodleSection>> getSections(MoodleCourseUnit uc) async {
    final String url = NetworkRouter.getMoodleUrl() +
        '/course/view.php?id=' +
        uc.id.toString();

    final Future<Response> response = NetworkRouter.federatedGet(url);
    return _getSectionsFromResponse(await response, uc);
  }

  Future<List<MoodleSection>> _getSectionsFromResponse(
      Response response, MoodleCourseUnit courseUnit) async {
    final document = parse(response.body);
    final List<Element> sectionElements =
        document.querySelectorAll('.topics > .section');

    final List<MoodleSection> moodleSections = [];

    for (final sectionElement in sectionElements) {
      //Read section info
      final String sectionId =
          sectionElement.attributes['aria-labelledby'].split('-')[1];
      final Element content = sectionElement.querySelector('.content');
      final String title = content.querySelector('h3').text;
      final String summary = content.querySelector('.summary').text;
      final List<Element> activityElements =
          content.querySelectorAll('.activity');

      //Read section modules
      final List<MoodleActivity> sectionActivities = [];
      for (final activityElement in activityElements) {
        final MoodleActivity activity =
            await _getActivityFromElement(activityElement);

        if (activity is MoodleActivity){
          sectionActivities.add(activity);
        }
      }

      moodleSections.add(MoodleSection(int.parse(sectionId), title, summary,
          activities: sectionActivities, courseUnitId: courseUnit.id));
    }

    return moodleSections;
  }

  Future<MoodleActivity> _getActivityFromElement(Element element) async {
    MoodleActivityType type;
    for (String elemClass in element.classes) {
      type = stringToActivityEnum(elemClass);
      if (type != null) {
        break;
      }
    }
    if (type == null) {
      return null;
    }
    switch (type) {
      case MoodleActivityType.sigarracourseinfo:
        // TODO: Handle this case.
        final String courseInfoPageUrl =
            element.querySelector('.aalink').attributes['href'];

        final Response response =
            await NetworkRouter.federatedGet(courseInfoPageUrl);

        //Logger().i(response.body);

        if (response.statusCode != 200) {
          // throw error
          print('Too fast, cant wait');
        }

        final document = parse(response.body);
        final Map<String, String> content = Map();

        print('Uc name ' + document.querySelector('h1').text);

        content[document.querySelector('h1').text] =
            'Ativa?    Sim\nUnidade Responsável:    Departamento de Engenharia Informática\nCurso/CE Responsável:    Licenciatura em Engenharia Informática e Computação';
        content['Língua de trabalho'] = 'Português';
        content['Objetivos'] =
            'Familiarizar-se com os métodos de engenharia e gestão necessários ao desenvolvimento de sistemas de software complexos e/ou em larga escala, de forma economicamente eficaz e com elevada qualidade.';
        content['Melhoria de Classificação'] =
            'A classificação da componente EF pode ser melhorada na época de recurso.\nRealização de trabalhos alternativos na época seguinte da disciplina.';
        return SigarraCourseInfo(
            1, 'UC Info - ' + document.querySelector('h1').text, content);

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

        final List<String> pageContent = [
          'Have a look at these pages:',
          'https://docs.oracle.com/javase/tutorial/rmi/overview.html',
          'https://docs.oracle.com/javase/8/docs/technotes/guides/rmi/hello/hello-world.html',
          'To run the code in Linux based system (see explanation in the link above):',
          'rmiregistry &',
          'java -Djava.rmi.server.codebase=file:./ example.hello.Server &',
          'java example.hello.Client'
        ];

        return PageActivity(2, 'Example RMI', pageContent.join('\n'));

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
