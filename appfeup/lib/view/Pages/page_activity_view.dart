import 'package:flutter/material.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page.dart';
import 'package:uni/view/Pages/moodle_activity_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';

import '../Widgets/moodle_course_info_section_view.dart';

class PageActivityView extends MoodleActivityPageView {
  final PageActivity pageInfo;

  PageActivityView(this.pageInfo) : super(pageInfo);

  @override
  State<StatefulWidget> createState() => PageActivityViewState(this.pageInfo);
}

class PageActivityViewState extends UnnamedPageView {
  PageActivity pageInfo;

  PageActivityViewState(this.pageInfo);

  @override
  Widget getBody(BuildContext context) {
    return ListView(children:  createContent(context));
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }


  List<Widget> createContent(BuildContext context) {
    final List<Widget> widgets = [];

    this.pageInfo.content.forEach((value) {
      widgets.add(
          Container(
              child: MoodleCourseInfoSection(value)
          )
      );
    });

    return widgets;
  }
}
