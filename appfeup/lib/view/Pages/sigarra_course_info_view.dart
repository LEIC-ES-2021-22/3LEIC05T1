import 'package:flutter/material.dart';
import 'package:uni/model/entities/moodle/activities/sigarraCourseInfo.dart';
import 'package:uni/view/Pages/activity_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';


class SigarraCourseInfoPageView extends ActivityPageView {
  SigarraCourseInfo ucInfo;
  SigarraCourseInfoPageView(SigarraCourseInfo ucInfo):super(ucInfo);
  @override
  State<StatefulWidget> createState() => SigarraCourseInfoPageViewState(this.ucInfo);
}

/// Manages the 'Personal user page' section.
class SigarraCourseInfoPageViewState extends UnnamedPageView {
  SigarraCourseInfo ucInfo;

  SigarraCourseInfoPageViewState(this.ucInfo);

  @override
  Widget getBody(BuildContext context) {

    return ListView(
        children:
            [createTitle(context)] + createContent(context)

    );
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }

  Widget createTitle(BuildContext context)
  {
    return  Flexible(
        child: Container(
          child: Text(this.ucInfo.title,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .apply(fontSizeFactor: 1.3)),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only(top: 15, bottom: 10),
        )
    );
  }



  List<Widget> createContent(BuildContext context){
    List<Widget> widgets = [];

    this.ucInfo.content.forEach((key, value) {
      widgets.add(
          Flexible(
          child: Container(
            child: Text(key,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .apply(color: Color.fromARGB(255, 0x75, 0x17, 0x1e))
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15),
            margin: EdgeInsets.only(top: 10, bottom: 8),
          ),
      ),
      );

      widgets.add(
        Flexible(
          child: Container(
            child: Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .apply(fontSizeFactor: 0.8)
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15),
            margin: EdgeInsets.only(top: 10, bottom: 8),
          ),
        ),
      );

    });
      return widgets;

  }



}

