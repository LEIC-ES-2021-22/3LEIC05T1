import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_file/open_file.dart';
import 'package:uni/controller/load_info.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/moodle/activities/moodle_resource.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/redux/action_creators.dart';

class MoodleResourceWidget extends StatefulWidget {
  final MoodleResource resource;

  MoodleResourceWidget(this.resource, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MoodleResourceState();
  }
}

class MoodleResourceState extends State<MoodleResourceWidget> {
    final double borderRadius = 10.0;
    final double padding = 12.0;



    @override
    Widget build(BuildContext context) {
      return Flexible(
        child: RichText(
          text: TextSpan(
              text: widget.resource.title,
              style: TextStyle(
                  color: Colors.red, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final String filePath =
                  await getMoodleResource(null, widget.resource);
                  OpenFile.open(filePath);
                }
          ),
        )
      );
    }

  }