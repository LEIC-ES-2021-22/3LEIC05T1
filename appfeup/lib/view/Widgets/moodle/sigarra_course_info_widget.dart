import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/moodle/activities/moodle_sigarra_course_info.dart';
import 'package:uni/view/Pages/sigarra_course_info_view.dart';

class SigarraCourseInfoWidget extends StatefulWidget {
  final SigarraCourseInfo uc;

  SigarraCourseInfoWidget(this.uc, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SigarraCourseInfoState(this.uc);
  }
}

class SigarraCourseInfoState extends State<SigarraCourseInfoWidget> {
  SigarraCourseInfo uc;
  final double borderRadius = 10.0;
  final double padding = 12.0;

  SigarraCourseInfoState(this.uc);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Icon(
            Icons.info,
            size: Theme.of(context).iconTheme.size,
            color: Theme.of(context).accentColor,
          )),
      Expanded(
          child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: RichText(
            overflow: TextOverflow.fade,
            text: TextSpan(
                text: widget.uc.title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    .apply(decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SigarraCourseInfoPageView(this.uc)),
                    );
                  })),
      )),
    ]));
  }
}
