import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MoodleCourseInfoString extends StatefulWidget {
  final String text;

  MoodleCourseInfoString(this.text, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MoodleCourseInfoStringState();
  }

  Widget buildContent(BuildContext context) {
    return Wrap(children: <Widget>[
      Divider(color: Colors.grey.shade500),
      Row(children: <Widget>[
        Flexible(
            child: Text(
              this.text,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
            ))
      ]),
    ]);
  }
}

class MoodleCourseInfoStringState extends State<MoodleCourseInfoString> {
  final double borderRadius = 10.0;
  final double padding = 12.0;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Container(
              padding: EdgeInsets.only(
                left: this.padding,
                right: this.padding,
                bottom: this.padding,
              ),
              child: widget.buildContent(context),
            ),
          ),
        ),
      ),
    );
  }
}
