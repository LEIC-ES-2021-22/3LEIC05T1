import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/i_am_logged_in.dart';
import 'steps/internet_connection_available.dart';
import 'steps/internet_connection_unavailable.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [
      RegExp(
          'test/acceptance/features/moodle/*.*.feature')
    ]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: 'test/acceptance/test_report.json')
    ]
    ..stepDefinitions = [
      iAmLoggedIn(),
      internetConnectionAvailable(),
      internetConnectionUnavailable(),
    ] //insert custom steps
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = 'test/acceptance/app.dart';
  return GherkinRunner().execute(config);
}
