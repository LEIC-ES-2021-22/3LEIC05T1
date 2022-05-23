import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/i_am_logged_in.dart';
import 'steps/internet_connection_available.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [
      Glob(
          r'test/acceptance/features/test/acceptance/features/moodle/list*.feature')
    ]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: 'test/acceptance/test_report.json')
    ]
    ..stepDefinitions = [
      iAmLoggedIn(),
      internetConnectionAvailable(),
    ] //insert custom steps
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = 'test/acceptance/app.dart';
  return GherkinRunner().execute(config);
}
