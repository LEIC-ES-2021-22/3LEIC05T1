import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric iAmLoggedIn() {
  return given<FlutterWorld>(
    "I'm logged in the uni app",
    (context) async {
      final locator = find.byValueKey('fotoicon');
      FlutterDriverUtils.isPresent(context.world.driver, locator);
    },
  );
}
