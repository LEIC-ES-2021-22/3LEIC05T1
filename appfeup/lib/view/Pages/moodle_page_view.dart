import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/curricular_unit_card.dart';


/// Manages the 'schedule' sections of the app
class MoodlePageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoodlePageViewState();
}

/// Tracks the state of `ExamsLists`.
class MoodlePageViewState extends SecondaryPageViewState {
  final double borderRadius = 10.0;

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) {

      },
      builder: (context, exams) {
        return UcsList();
      },
    );
  }
}

/// Manages the 'Exams' section in the user's personal area and 'Exams Map'.
class UcsList extends StatelessWidget {


  UcsList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [CurricularUnitCard()],
          ),
        )
      ],
    );
  }


}