import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/moodle/activities/moodle_sigarra_course_info.dart';
import 'package:uni/view/Pages/page_activity_view.dart';
import 'package:uni/view/Pages/sigarra_course_info_view.dart';

import '../../../model/entities/moodle/activities/moodle_page.dart';

class PageActivityWidget extends StatefulWidget {
  final PageActivity pageActivity;

  PageActivityWidget(this.pageActivity, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageActivityState(this.pageActivity);
  }
}

class PageActivityState extends State<PageActivityWidget> {
  final PageActivity pageActivity;
  final double borderRadius = 10.0;
  final double padding = 12.0;

  PageActivityState(this.pageActivity);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[

              Container(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Icon(
                    Icons.wysiwyg,
                    size: Theme.of(context).iconTheme.size,
                    color: Theme.of(context).accentColor,
                  )
              ),
              Expanded( child:
              RichText(
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                      text: this.pageActivity.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          .apply(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = ()  {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageActivityView(this.pageActivity)),
                          );
                        }
                  )
              ),
              ),
            ]
        ));
  }
}
