import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/moodle_fetcher/moodle_uc_sections_fetcher.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page_entities/moodle_page_section.dart';
import 'package:uni/model/entities/moodle/activities/moodle_sigarra_course_info.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_section.dart';
import 'package:uni/model/utils/moodle_activity_type.dart';

import '../../model/entities/moodle/activities/moodle_page.dart';
import '../../model/entities/moodle/activities/moodle_page_entities/moodle_page_list.dart';
import '../../model/entities/moodle/activities/moodle_page_entities/moodle_page_section.dart';
import '../../model/entities/moodle/activities/moodle_page_entities/moodle_page_section_title.dart';
import '../../model/entities/moodle/activities/moodle_page_entities/moodle_page_table.dart';
import '../networking/network_router.dart';

class MoodleUcSectionsFetcherHtml implements MoodleUcSectionsFetcher {
  @override
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
    switch (type) {
      case MoodleActivityType.sigarracourseinfo:
        // TODO: Handle this case.
        final List<dynamic> content = await _fetchSigarraCourseInfo(element);
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
        // TODO: Handle this case
        final List<dynamic> moodlePage = await _fetchMoodlePage(element);
        final shortDescritptionElem =
            element.querySelector('.contentafterlink');
        final shortDescription = shortDescritptionElem != null
            ? _parseGeneralHtml(element.querySelector('.contentafterlink'))
                .join('\n')
            : '';

        Logger().i('Short description' + shortDescription.toString());

        Logger().i('Page', moodlePage);

        return PageActivity(2, element.querySelector('.instancename').text,
            shortDescription, moodlePage);

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

  Future<List> _fetchSigarraCourseInfo(Element htmlElement) async {
    final String courseInfoPageUrl =
        htmlElement.querySelector('.aalink').attributes['href'];

    final Response response =
        await NetworkRouter.federatedGet(courseInfoPageUrl);

    if (response.statusCode != 200) {
      // throw error
    }

    final page = parse(response.body);
    final courseInfoHtml = page.querySelector('#sigarracourseinfo').innerHtml;

    final document = parse(courseInfoHtml);
    final List<MoodlePageSection> content = [];

    // UC name
    final ucName = document.querySelectorAll('#conteudoinner > h1')[1];
    final List<dynamic> ucNameInfo = [];
    // Uc code and short name
    for (final elem in ucName.nextElementSibling
        .getElementsByClassName('formulario-legenda')) {
      ucNameInfo.add(elem.text + elem.nextElementSibling.text);
    }

    content.add(
        MoodlePageSection(MoodlePageSectionTitle(ucName.text, 1), ucNameInfo));

    // Occurrence
    final occurrence = document.querySelector('h2');
    // Occurrence Info
    final List<dynamic> occurenceInfo = [];
    for (final element in occurrence.nextElementSibling
        .getElementsByClassName('formulario-legenda')) {
      occurenceInfo.add(element.text + element.nextElementSibling.text);
    }

    content.add(MoodlePageSection(
        MoodlePageSectionTitle(occurrence.text, 2), occurenceInfo));

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

          content.add(MoodlePageSection(MoodlePageSectionTitle(element.text, 3),
              [MoodlePageTable(table)]));
          break;

        case 'Docência - Responsabilidades':
          final List<List<String>> responsabilities = [];
          for (final d
              in element.nextElementSibling.getElementsByClassName('d')) {
            responsabilities.add([d.children[0].text, d.children[1].text]);
          }

          content.add(MoodlePageSection(MoodlePageSectionTitle(element.text, 3),
              [MoodlePageTable(responsabilities)]));
          break;

        case 'Docência - Horas':
          final List<List<String>> classtime = [];
          for (final elem in element.nextElementSibling
              .getElementsByClassName('formulario-legenda')) {
            classtime.add([elem.text, elem.nextElementSibling.text]);
          }

          final List<dynamic> teacherTimesInfo = [];
          List<List<String>> teacherTimes = [];
          String type = '';

          for (final d in element.nextElementSibling.nextElementSibling
              .getElementsByClassName('d')) {
            if (d.children[0].classes.contains('k')) {
              if (type != '') {
                teacherTimesInfo.add(MoodlePageSectionTitle(type, 4));
                teacherTimesInfo.add(MoodlePageTable(teacherTimes));
                teacherTimes = [];
              }
              type = d.children[0].text;
              continue;
            }
            teacherTimes.add([d.children[0].text, d.children[2].text]);
          }
          final List<dynamic> timesContent = [];
          timesContent.add(MoodlePageTable(classtime));
          timesContent.addAll(teacherTimesInfo);
          content.add(MoodlePageSection(
              MoodlePageSectionTitle(element.text, 3), timesContent));
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

          content.add(MoodlePageSection(MoodlePageSectionTitle(element.text, 3),
              [MoodlePageTable(table)]));
          break;

        default:
          // Extract section HTML code from complete course info page
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
            sectionHtml =
                sectionHtml.substring(0, sectionHtml.indexOf(elem.outerHtml)) +
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
          final List<dynamic> courseInfoGeneral =
              _parseGeneralHtml(section.body);

          content.add(MoodlePageSection(
              MoodlePageSectionTitle(element.text, 3), courseInfoGeneral));
          break;
      }
    }
    return content;
  }

  Future<List> _fetchMoodlePage(element) async {
    final String pageUrl = element.querySelector('.aalink').attributes['href'];

    final Response response = await NetworkRouter.federatedGet(pageUrl);

    if (response.statusCode != 200) {
      // throw error
    }

    final Document page = parse(response.body);

    final pageTitle =
        MoodlePageSectionTitle(page.body.querySelector('h2').text, 2);

    // Use main content and general parser

    return [
      MoodlePageSection(
          pageTitle, _parseGeneralHtml(page.body.querySelector('.generalbox')))
    ];
  }

  List<dynamic> _parseGeneralHtml(Element document) {
    final List<dynamic> contents = [];

    for (final elem in document.children) {
      switch (elem.localName) {
        case 'div':
          contents.addAll(_parseGeneralHtml(elem));
          break;

        case 'h1':
          contents.add(MoodlePageSectionTitle(elem.text, 1));
          break;

        case 'h2':
          contents.add(MoodlePageSectionTitle(elem.text, 2));
          break;

        case 'h3':
          contents.add(MoodlePageSectionTitle(elem.text, 3));
          break;

        case 'h4':
          contents.add(MoodlePageSectionTitle(elem.text, 4));
          break;
        case 'h5':
          contents.add(MoodlePageSectionTitle(elem.text, 5));
          break;

        case 'h6':
          contents.add(MoodlePageSectionTitle(elem.text, 6));
          break;

        case 'p':
          if (elem.text == '') {
            break;
          }

          contents.add(elem.text);
          break;

        case 'table':
          final List<List<String>> t = [];
          t.add(elem.querySelectorAll('th').map((e) => e.text).toList());
          t.add(elem.querySelectorAll('td').map((e) => e.text).toList());
          contents.add(MoodlePageTable(t));
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
            contents.add(MoodlePageList(entries));
            break;
          }
          continue;

        default:
          contents.add(elem.text);
      }
    }

    return contents;
  }
}
