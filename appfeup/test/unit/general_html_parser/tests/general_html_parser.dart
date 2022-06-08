import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart';
import 'package:uni/controller/moodle_fetcher/moodle_uc_sections_fetcher_html.dart';

void main() {
  group('Parse html in moodle page', () {
    test('test full 1', () {
      final resource_path =
          'test/unit/general_html_parser/resources/sample_full_page_1.html';

      final file = File(resource_path);
      final document = parse(file.readAsStringSync());

      final result = MoodleUcSectionsFetcherHtml.parseGeneralHtml(document.body
          .querySelector('#maincontent')
          .nextElementSibling
          .nextElementSibling);

      expect(result.length, 7);
    });
  });

  group('Parse html in short description', () {
    test('test short 1', () {
      final resource_path =
          'test/unit/general_html_parser/resources/sample_short_description_1.html';

      final file = new File(resource_path);
      final document = parse(file.readAsStringSync());

      final List<dynamic> parsed =
          MoodleUcSectionsFetcherHtml.parseGeneralHtml(document.body);
      expect(parsed.length, 1);
    });
  });
}
