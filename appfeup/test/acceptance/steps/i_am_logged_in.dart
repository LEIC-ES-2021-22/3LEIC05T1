import 'package:flutter/widgets.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

StepDefinitionGeneric iAmLoggedIn() {
  return given<FlutterWorld>(
    "that I'm logged in the uni app",
    (context) async {
      print('ola');
      final locator = find.byValueKey(Key('fotoicon'));
      FlutterDriverUtils.isPresent(context.world.driver, locator);
    },
  );
}
