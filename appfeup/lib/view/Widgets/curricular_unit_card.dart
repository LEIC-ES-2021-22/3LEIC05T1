import 'package:uni/controller/exam.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/date_rectangle.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'package:uni/view/Widgets/schedule_event_rectangle.dart';
import 'package:uni/view/Widgets/schedule_row.dart';

import 'generic_card.dart';


class CurricularUnitCard extends GenericCard {
  CurricularUnitCard({Key key}) : super(key: key);

  CurricularUnitCard.fromEditingInformation
      (Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, false, onDelete);

  @override
  //TODO - title vindo do do constructor
  String getTitle() => 'Engenharia de software';

  @override
  onClick(BuildContext context) =>
      //TODO - criar uma nova página
      print('ola');


  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, RequestStatus>(
      converter: (store) {
        return store.state.content['examsStatus'];
      },
      builder: (context, examsInfo) => Container(
        //TODO - Icon a identificar que tem moodle
      ),
    );
  }



}
