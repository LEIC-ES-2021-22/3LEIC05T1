import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/moodle_course_unit.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/curricular_unit_card.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/page_title.dart';


/// Manages the 'schedule' sections of the app
class UcsPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UcsPageViewState();
}

/// Tracks the state of `ExamsLists`.
class UcsPageViewState extends SecondaryPageViewState {
  final double borderRadius = 10.0;

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState,
        Tuple3<List<CourseUnit>,
            Map<int, MoodleCourseUnit>,
            RequestStatus>
    >(
      converter: (store) {
        return Tuple3(store.state.content['currUcs'],
                      store.state.content['moodleCourseUnitsMap'],
                      store.state.content['moodleCourseUnitsStatus']);
      },
      builder: (context, tuple) {
        final List<Widget> result = [];
        result.add(getPageTitle());
        switch(tuple.item3){
          case RequestStatus.none:
            // TODO: Handle this case.
            break;
          case RequestStatus.busy:
            //result.add(getPageTitle());

            result.add(Container(
                padding: EdgeInsets.all(22.0),
                child: Center(child: CircularProgressIndicator()))
            )
            ;
            return ListView(children: result);
            break;
          case RequestStatus.failed:
            result.add(Text('Erro ao carregar moodle'));
            return ListView(children: result,);

          case RequestStatus.successful:
            result.add(UcsList(ucs: tuple.item1,
                moodleCourseUnitsMap: tuple.item2));
            return ListView(children: result,);
        }
        return ListView(children: result,);
        return Container();
      },
    );
  }
  Container getPageTitle() {
    return Container(
        padding: EdgeInsets.only(bottom: 12.0),
        child: PageTitle(name: 'Unidades curriculares'));
  }
}

/// Manages the 'Exams' section in the user's personal area and 'Exams Map'.
class UcsList extends StatelessWidget {
  final List<CourseUnit> ucs;
  final Map<int, MoodleCourseUnit> moodleCourseUnitsMap;
  UcsList({Key key, @required this.ucs, @required this.moodleCourseUnitsMap}) : super(key: key);
  
  List<CurricularUnitCard> createAllUnitCards(){
      final List<CurricularUnitCard> curricularUnitCards = [];
      for (CourseUnit courseUnit in ucs) {
        MoodleCourseUnit moodleCourseUnit = moodleCourseUnitsMap[courseUnit.moodleId];
          curricularUnitCards
              .add(CurricularUnitCard(courseUnit, moodleCourseUnit));
      }
      return curricularUnitCards;
  }
  @override
  Widget build(BuildContext context) {
    return
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //TODO - Por a retornar uma lista de cards
            children: createAllUnitCards(),
          ),
        );
  }


}