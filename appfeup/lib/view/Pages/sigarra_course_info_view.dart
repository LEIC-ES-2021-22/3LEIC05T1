import 'package:flutter/material.dart';
import 'package:uni/model/entities/moodle/activities/moodle_sigarra_course_info.dart';
import 'package:uni/view/Pages/moodle_activity_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/moodle_course_info_section_view.dart';

class SigarraCourseInfoPageView extends MoodleActivityPageView {
  final SigarraCourseInfo ucInfo;

  SigarraCourseInfoPageView(this.ucInfo) : super(ucInfo);

  @override
  State<StatefulWidget> createState() =>
      SigarraCourseInfoPageViewState(this.ucInfo);
}

/// Manages the 'Personal user page' section.
class SigarraCourseInfoPageViewState extends UnnamedPageView {
  SigarraCourseInfo ucInfo;

  SigarraCourseInfoPageViewState(this.ucInfo);

  @override
  Widget getBody(BuildContext context) {
    return ListView(children: createContent(context));
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }

  List<Widget> createContent(BuildContext context) {
    final List<Widget> widgets = [];

    this.ucInfo.content.forEach((value) {
      widgets.add(
          Container(
              child: MoodleCourseInfoSection(value)
          )
      );
    });
    return widgets;
  }
}
