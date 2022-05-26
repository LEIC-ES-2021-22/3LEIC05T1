import 'package:uni/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/view/Pages/moodle_page_view.dart';
import 'generic_card.dart';

class CurricularUnitCard extends GenericCard {
  final MoodleCourseUnit moodleCourseUnit;
  final CourseUnit courseUnit;
  CurricularUnitCard(this.courseUnit, this.moodleCourseUnit, {Key key}) : super(key: key);

  @override
  String getTitle() => courseUnit.name;

  @override
  onClick(BuildContext context) {
      if(courseUnit.hasMoodle) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MoodlePageView(this.moodleCourseUnit)
            )
        );
      }
  }


  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, RequestStatus>(
      //TODO - Ver isto
      converter: (store) {
        return store.state.content['examsStatus'];
      },
      builder: (context, examsInfo) => 
              courseUnit.hasMoodle ? Image.asset(
                'assets/images/moodle_icon.png')
                  : Container()
          
       //Text('has moodle')
       
       
      /*Container(
       
        context: context,
        content: "has moodle",
        contentChecker: examsInfo.item1 != null,
        onNullContent: Center(
          child: Text('')
        ),
        
        
      )*/
    );
  }



}
