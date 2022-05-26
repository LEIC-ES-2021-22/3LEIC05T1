import 'package:flutter/material.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page.dart';
import 'package:uni/view/Pages/moodle_activity_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';

class PageActivityView extends MoodleActivityPageView {
  PageActivity pageInfo;

  PageActivityView(PageActivity pageInfo) : super(pageInfo);

  @override
  State<StatefulWidget> createState() => PageActivityViewState(this.pageInfo);
}

/// Manages the 'Personal user page' section.
class PageActivityViewState extends UnnamedPageView {
  PageActivity pageInfo;

  PageActivityViewState(this.pageInfo);

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
      child: Text(this.pageInfo.title,
          style:
              Theme.of(context).textTheme.headline6.apply(fontSizeFactor: 1.3)),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(top: 15, bottom: 10),
    ));
  }

  List<Widget> createContent(BuildContext context) {
    List<Widget> widgets = [];

    ((value) {
      widgets.add(
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
    })(this.pageInfo.description);

    return widgets;
  }
}
