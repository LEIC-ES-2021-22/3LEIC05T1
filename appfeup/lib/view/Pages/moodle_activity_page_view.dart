import 'package:flutter/material.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page.dart';
import 'package:uni/model/entities/moodle/activities/moodle_sigarra_course_info.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/view/Pages/page_activity_view.dart';
import 'package:uni/view/Pages/sigarra_course_info_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';

class ActivityPageView extends StatefulWidget {
  final MoodleActivity info;

  ActivityPageView(this.info);

  @override
  State<StatefulWidget> createState() {
    if (this.info is SigarraCourseInfo) {
      return SigarraCourseInfoPageViewState(this.info);
    } else if (this.info is PageActivity) {
      return PageActivityViewState(this.info);
    } else {
      return ActivityPageViewState(this.info);
    }
  }
}

/// Manages the 'Personal user page' section.
class ActivityPageViewState extends UnnamedPageView {
  MoodleActivity info;

  ActivityPageViewState(this.info);

  @override
  Widget getBody(BuildContext context) {
    return Text('Not implemented');
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }
}
