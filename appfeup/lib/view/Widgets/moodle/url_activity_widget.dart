import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/moodle/activities/moodle_sigarra_course_info.dart';
import 'package:uni/model/entities/moodle/activities/moodle_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class URLActivityWidget extends StatefulWidget {
  final UrlActivity urlActivity;

  URLActivityWidget(this.urlActivity, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return URLActivityState(this.urlActivity);
  }
}

class URLActivityState extends State<URLActivityWidget> {
  final UrlActivity urlActivity;
  final double borderRadius = 10.0;
  final double padding = 12.0;

  URLActivityState(this.urlActivity);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Icon(
            Icons.link,
            size: Theme.of(context).iconTheme.size,
            color: Theme.of(context).accentColor,
          )),
      Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              color: Colors.white,
              child: RichText(
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                      text: this.urlActivity.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          .apply(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchURL();
                        }
                  )
              )
          )
          )
      )
    ]));
  }

  _launchURL() async {

    final Uri url = Uri.parse(this.urlActivity.url);
    if (await canLaunchUrl(url)) {
      final Response response = await NetworkRouter.federatedGet(this.urlActivity.url);
      await launchUrl(response.request.url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
