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
    return ListView(children: [createTitle(context)] + createContent(context));
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }

  Widget createTitle(BuildContext context) {
    return Flexible(
        child: Container(
      child: Text(this.ucInfo.title,
          style:
              Theme.of(context).textTheme.headline6.apply(fontSizeFactor: 1.3)),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(top: 15, bottom: 10),
    ));
  }

  List<Widget> createContent(BuildContext context) {
    final List<Widget> widgets = [];

    this.ucInfo.content.forEach((value) {

      /*if (value is String) {
        widgets.add(MoodleCourseeInfoString(value).buildContent(context));
=======
      if (value is String) {
        widgets.add(MoodleCourseInfoString(value).buildContent(context));
>>>>>>> main
      }
      else {

        widgets.add(Text(value.toString()));
      }*/
    });
    return widgets;
      /*widgets.add(

        Flexible(
          child: Container(
            child: Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .apply(color: Color.fromARGB(255, 0x75, 0x17, 0x1e))),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15),
            margin: EdgeInsets.only(top: 10, bottom: 8),
          ),
        ),
      );*/

      /*widgets.add(
        Flexible(
          child: Container(
            child: Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .apply(fontSizeFactor: 0.8)),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15),
            margin: EdgeInsets.only(top: 10, bottom: 8),
          ),
        ),
      );
    });*/

  }
}
