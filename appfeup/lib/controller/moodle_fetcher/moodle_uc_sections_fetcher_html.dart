import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/moodle_fetcher/moodle_uc_sections_fetcher.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/activities/course_info/moodle_course_info_list.dart';
import 'package:uni/model/entities/moodle/activities/course_info/moodle_course_info_section.dart';
import 'package:uni/model/entities/moodle/activities/moodle_sigarra_course_info.dart';
import 'package:uni/model/entities/moodle/activities/moodle_url.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_section.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/utils/moodle_activity_type.dart';

import '../../model/entities/moodle/activities/course_info/moodle_course_info_table.dart';
import '../../model/entities/moodle/activities/course_info/moodle_course_info_title.dart';
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

        if (activity is MoodleActivity) {
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
    int id = int.parse(element.attributes['id'].split('-')[1]);

    String title;
    final Element noLinkElem = element.querySelector('.contentwithoutlink');
    if(noLinkElem != null){
      title = noLinkElem.text;
    } else {
      title = element.querySelector('.aalink').text;
    }
    switch (type) {
      case MoodleActivityType.sigarracourseinfo:
        // TODO: Handle this case.
        final String courseInfoPageUrl =
            element.querySelector('.aalink').attributes['href'];

        final Response response =
            await NetworkRouter.federatedGet(courseInfoPageUrl);

        if (response.statusCode != 200) {
          // throw error
        }

        final page = parse(response.body);
        final courseInfoHtml =
            page.querySelector('#sigarracourseinfo').innerHtml;

        final document = parse(courseInfoHtml);
        final List<CourseInfoSection> content = [];

        // UC name
        final ucName = document.querySelectorAll('#conteudoinner > h1')[1];
        final List<dynamic> ucNameInfo = [];
        // Uc code and short name
        for (final elem in ucName.nextElementSibling
            .getElementsByClassName('formulario-legenda')) {
          ucNameInfo.add(elem.text + elem.nextElementSibling.text);
        }

        content.add(
            CourseInfoSection(CourseInfoTitle(ucName.text, 1), ucNameInfo));

        // Occurrence
        final occurrence = document.querySelector('h2');
        // Occurrence Info
        final List<dynamic> occurenceInfo = [];
        for (final element in occurrence.nextElementSibling
            .getElementsByClassName('formulario-legenda')) {
          occurenceInfo.add(element.text + element.nextElementSibling.text);
        }

        content.add(CourseInfoSection(
            CourseInfoTitle(occurrence.text, 2), occurenceInfo));

        for (final element in document.querySelectorAll('h3')) {
          switch (element.text) {
            case 'Ciclos de Estudo/Cursos':
              // Degree / Study Cycle Info
              final Map<String, String> studyCycleInfo = Map();
              final th = element.nextElementSibling.querySelectorAll('th');
              final td = element.nextElementSibling.querySelectorAll('td');

              for (int i = 0; i < th.length; i += 1) {
                studyCycleInfo[th[i].text] = td[i].text;
              }

              List<List<String>> table = [];
              table.add(th.map((e) => e.text).toList());
              table.add(td.map((e) => e.text).toList());

              content.add(CourseInfoSection(
                  CourseInfoTitle(element.text, 3), [CourseInfoTable(table)]));
              break;

            case 'Docência - Responsabilidades':
              final List<List<String>> responsabilities = [];
              for (final d
                  in element.nextElementSibling.getElementsByClassName('d')) {
                responsabilities.add([d.children[0].text, d.children[1].text]);
              }

              content.add(CourseInfoSection(CourseInfoTitle(element.text, 3),
                  [CourseInfoTable(responsabilities)]));
              break;

            case 'Docência - Horas':
              final List<List<String>> classtime = [];
              for (final elem in element.nextElementSibling
                  .getElementsByClassName('formulario-legenda')) {
                classtime.add([elem.text, elem.nextElementSibling.text]);
              }

              List<dynamic> teacherTimesInfo = [];
              List<List<String>> teacherTimes = [];
              String type = '';

              for (final d in element.nextElementSibling.nextElementSibling
                  .getElementsByClassName('d')) {
                if (d.children[0].classes.contains('k')) {
                  if (type != '') {
                    teacherTimesInfo.add(CourseInfoTitle(type, 4));
                    teacherTimesInfo.add(CourseInfoTable(teacherTimes));
                    teacherTimes = [];
                  }
                  type = d.children[0].text;
                  continue;
                }
                teacherTimes.add([d.children[0].text, d.children[2].text]);
              }
              List<dynamic> timesContent = [];
              timesContent.add(CourseInfoTable(classtime));
              timesContent.addAll(teacherTimesInfo);
              content.add(CourseInfoSection(
                  CourseInfoTitle(element.text, 3), timesContent));
              break;

            case 'Componentes de Avaliação':
            case 'Componentes de Ocupação':
              final List<List<String>> table = [];

              table.add(element.nextElementSibling
                  .querySelectorAll('th')
                  .map((e) => e.text)
                  .toList());

              for (final elem
                  in element.nextElementSibling.getElementsByClassName('d')) {
                table.add([elem.text, elem.nextElementSibling.text]);
              }

              table.add(element.nextElementSibling
                  .querySelector('.totais')
                  .children
                  .map((e) => e.text)
                  .toList());

              content.add(CourseInfoSection(
                  CourseInfoTitle(element.text, 3), [CourseInfoTable(table)]));
              break;

            default:
              // Extract section HTML code from complete courseinfo page
              Element nextElement = element;

              while (nextElement.nextElementSibling != null &&
                  (nextElement.nextElementSibling.localName != 'h3' &&
                      nextElement.nextElementSibling.localName != 'script')) {
                nextElement = nextElement.nextElementSibling;
              }

              String sectionHtml = courseInfoHtml.substring(
                  courseInfoHtml.indexOf(element.outerHtml) +
                      element.outerHtml.length,
                  nextElement.nextElementSibling == null
                      ? courseInfoHtml.indexOf(
                          '</div>',
                          courseInfoHtml.indexOf(element.outerHtml) +
                              element.outerHtml.length)
                      : courseInfoHtml
                          .indexOf(nextElement.nextElementSibling.outerHtml));

              // Add missing tags, in order to read loose text
              Document section =
                  parse('<html><body>' + sectionHtml + '</body></html>');
              for (final elem in section.body.children) {
                if (elem.localName == 'br') {
                  continue;
                }
                sectionHtml = sectionHtml.substring(
                        0, sectionHtml.indexOf(elem.outerHtml)) +
                    '</p>' +
                    elem.outerHtml +
                    '<p>' +
                    sectionHtml.substring(sectionHtml.indexOf(elem.outerHtml) +
                        elem.outerHtml.length);
              }
              sectionHtml = '<p>' + sectionHtml + '</p>';

              // Reparse the code
              section = parse('<html><body>' + sectionHtml + '</body></html>');
              // Extract info
              List<dynamic> courseInfoGeneral = [];
              for (final elem in section.body.children) {
                switch (elem.localName) {
                  case 'p':
                    if (elem.text == '') {
                      break;
                    }

                    courseInfoGeneral.add(elem.text);
                    break;

                  case 'table':
                    final List<List<String>> t = [];
                    t.add(elem
                        .querySelectorAll('th')
                        .map((e) => e.text)
                        .toList());

                    t.add(elem
                        .querySelectorAll('td')
                        .map((e) => e.text)
                        .toList());

                    break;

                  case 'ul':
                  case 'ol':
                    final List<String> entries = [];

                    for (final entry in elem.children) {
                      if (entry.localName != 'li') {
                        continue;
                      }
                      entries.add(entry.text);
                    }
                    if (entries.isNotEmpty) {
                      courseInfoGeneral.add(CourseInfoList(entries));
                      break;
                    }
                    continue;
                  default:
                    courseInfoGeneral.add(elem.text);
                }
              }
              content.add(CourseInfoSection(
                  CourseInfoTitle(element.text, 3), courseInfoGeneral));
              break;
          }
        }



        return SigarraCourseInfo(1, 'UC Info', content);

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
        String url = element.querySelector("a.aalink").attributes['href']
            + '&redirect=1';
        return UrlActivity(id, title, url);
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
