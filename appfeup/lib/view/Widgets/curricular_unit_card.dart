import 'package:flutter/gestures.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/view/Pages/moodle_page_view.dart';
import 'generic_card.dart';

class CurricularUnitCard extends StatefulWidget {
  final MoodleCourseUnit moodleCourseUnit;
  final CourseUnit courseUnit;

  CurricularUnitCard(this.courseUnit, this.moodleCourseUnit);

  State<StatefulWidget> createState() =>
      CurricularUnitCardState(this.courseUnit, this.moodleCourseUnit);
}

class CurricularUnitCardState extends State<CurricularUnitCard> {
  final MoodleCourseUnit moodleCourseUnit;
  final CourseUnit courseUnit;
  final double borderRadius = 10.0;
  final double padding = 12.0;

  CurricularUnitCardState(this.courseUnit, this.moodleCourseUnit);

  onClick(BuildContext context) {
    if (courseUnit.hasMoodle) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MoodlePageView(this.moodleCourseUnit)));
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onClick(context),
        child: Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(this.borderRadius)),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(0x1c, 0, 0, 0),
                        blurRadius: 7.0,
                        offset: Offset(0.0, 1.0))
                  ],
                  color: Theme.of(context).dividerColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(this.borderRadius))),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 60.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(this.borderRadius))),
                  width: (double.infinity),
                  child:
                      Row(
                        children: [
                                Expanded(
                                    child: Container(

                                    child: Text(
                                      this.courseUnit.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .apply(
                                              fontSizeDelta: -53,
                                              fontWeightDelta: -3),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10, vertical:15))),
                                courseUnit.hasMoodle
                                    ? Container(
                                        child:  Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                            'assets/images/moodle_icon.png')]),
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical:15))
                                : Container()
                              ]
                      ),
                  ),
                  ),
                ),
              ),
            );
  }
}
