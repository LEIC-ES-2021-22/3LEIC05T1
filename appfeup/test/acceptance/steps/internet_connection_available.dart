import 'dart:io';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

StepDefinitionGeneric internetConnectionAvailable() {
  return given<FlutterWorld>(
    'Internet connection is available',
    (context) async {
      return await hasNetwork();
    },
  );
}
