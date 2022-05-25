import 'dart:io';
import 'package:uni/controller/load_info.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/section.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/account_info_card.dart';
import 'package:uni/view/Widgets/course_info_card.dart';
import 'package:uni/view/Widgets/curricular_unit_card.dart';
import 'package:uni/view/Widgets/print_info_card.dart';
import 'package:uni/view/Widgets/section_card.dart';

class MoodlePageView extends StatefulWidget {
  MoodleCourseUnit uc;
  MoodlePageView(this.uc);
  @override
  State<StatefulWidget> createState() => MoodlePageViewState(this.uc);
}

/// Manages the 'Personal user page' section.
class MoodlePageViewState extends UnnamedPageView {
  MoodleCourseUnit uc;
  MoodlePageViewState(this.uc);

  @override
  Widget getBody(BuildContext context) {
    
    return ListView(
      children: 
          createSectionsList(context)
        
    );
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }

  List<Widget> createSectionsList(BuildContext context){
    final List<Widget> list = [
      Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
          child: 
         
            Text(
              this.uc.fullName,
              style:
                Theme.of(context).textTheme.headline6.apply(fontSizeFactor: 1.3),)
          ),
      ];
    final List<Section> sections = uc.sections;

    for (Section section in sections) {
          list.add(SectionCard(section));
    }

    return list;
  }
}

  /// Returns a list with all the children widgets of this page.
  /*List<Widget> childrenList(BuildContext context) {
    final List<Widget> list = [];
    list.add(Padding(padding: const EdgeInsets.all(5.0)));
    list.add(profileInfo(context));
    list.add(Padding(padding: const EdgeInsets.all(5.0)));
    for (var i = 0; i < courses.length; i++) {
      list.add(CourseInfoCard(
          course: courses[i],
          courseState:
              currentState == null ? '?' : currentState[courses[i].name]));
      list.add(Padding(padding: const EdgeInsets.all(5.0)));
    }
    list.add(PrintInfoCard());
    list.add(Padding(padding: const EdgeInsets.all(5.0)));
    list.add(AccountInfoCard());
    return list;
  }

  /// Returns a widget with the user's profile info (Picture, name and email).
  Widget profileInfo(BuildContext context) {
    return StoreConnector<AppState, Future<File>>(
      converter: (store) => loadProfilePic(store),
      builder: (context, profilePicFile) => FutureBuilder(
        future: profilePicFile,
        builder: (BuildContext context, AsyncSnapshot<File> profilePic) =>
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: getDecorageImage(profilePic.data))),
            Padding(padding: const EdgeInsets.all(8.0)),
            Text(name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400)),
            Padding(padding: const EdgeInsets.all(5.0)),
            Text(email,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}*/
