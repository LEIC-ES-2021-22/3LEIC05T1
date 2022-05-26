import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/model/entities/session.dart';
import 'moodle_ucs_fetcher.dart';

/// Class for fetching the user's lectures from the schedule's HTML page.
class MoodleUcsFetcherAPI extends MoodleUcsFetcher {
  /// Fetches the user's lectures from the schedule's HTML page.
  @override
  Future<List<MoodleCourseUnit>> getUcs(Session session) async {
    final String baseUrl = NetworkRouter.getMoodleUrl() +
        '/lib/ajax/service.php?sesskey=' +
        session.moodleSessionKey +
        '&info=core_course_get_enrolled_courses_by_timeline_classification';

    //Change to customfield to filter by semester
    final Map<String, dynamic> body = {
      'index': 0,
      'methodname':
          'core_course_get_enrolled_courses_by_timeline_classification',
      'args': {
        'offset': 0,
        'limit': 0,
        'classification': 'allincludinghidden', //allincludinghidden to show all
        'sort': 'shortname',
        'customfieldname': 'periodo',
        'customfieldvalue': '2',
      }
    };

    final String bodyStr = '[' + json.encode(body) + ']';

    final Response response =
        await NetworkRouter.federatedPost(baseUrl, bodyStr, session);

    return getUcsFromResponse(response);
  }

  Future<List<MoodleCourseUnit>> getUcsFromResponse(Response response) async {
    final json = jsonDecode(response.body)[0];

    if (json['error'] == 'true') {
      //Throw error
      return null;
    }

    final List<dynamic> courses = json['data']['courses'];
    return courses.map((course) => MoodleCourseUnit.fromMap(course)).toList();
  }
}
