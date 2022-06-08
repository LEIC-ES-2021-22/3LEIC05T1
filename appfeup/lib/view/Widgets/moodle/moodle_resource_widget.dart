import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:uni/controller/load_info.dart';
import 'package:uni/model/entities/moodle/activities/moodle_resource.dart';

enum ResourceStatus {
  downloading,
  downloaded,
  readyToDownload,
  failed
}

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
  ResourceStatus status;

  @override
  void initState() {
    super.initState();
    final String path = widget.resource.filePath;
    this.status = path == '' || path == null
        ? ResourceStatus.readyToDownload
        : ResourceStatus.downloaded;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Icon(
            Icons.file_copy,
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
                text: widget.resource.title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    .apply(decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    _downloadResource();
                  })
        ),
      )),
      Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          width: 25,
          height: 25,
          child: _getResourceStatusIcon(context))
    ]));
  }

  Widget _getResourceStatusIcon(BuildContext context) {
    switch (status) {
      case ResourceStatus.downloading:
        return Container(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      case ResourceStatus.downloaded:
        return IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.file_download_done,
              size: 20, color: Theme.of(context).accentColor),
          onPressed: _downloadResource,
        );
      case ResourceStatus.readyToDownload:
        return IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.file_download,
              size: 20, color: Theme.of(context).accentColor),
          onPressed: _downloadResource,
        );
      case ResourceStatus.failed:
        return IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.close,
              size: 20, color: Theme.of(context).accentColor),
          onPressed: _downloadResource,
        );
    }
  }

  Future<void> _downloadResource() async {
    bool download = true;
    bool delete = false;
    String filePath = widget.resource.filePath;
    bool exists = filePath != null && filePath != '' && await File(filePath).exists();
    if(exists) {
      await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Ficheiro encontra-se no sistema'),
              content: Text(
                  ''),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      download = false;
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('Abrir')
                ),
                TextButton(
                    onPressed: () {
                      delete = true;
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('Apagar')
                ),
                TextButton(
                  onPressed: () {
                    download = true;
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text('Download'),
                )
              ],
            ),
      );
    }

    if(delete){
      File(filePath).delete();
      filePath = '';
      download = false;
    }

    if(download) {
      setState(() {
        status = ResourceStatus.downloading;
      });
      filePath = await getMoodleResource(null, widget.resource);
      if(filePath == ''){
        setState((){
          status = ResourceStatus.failed;
        });
        return;
      }
    }
    if(filePath != '') {
      OpenResult result = await OpenFile.open(filePath);
      if (result.type == ResultType.fileNotFound) {
        filePath = '';
      }
    }
    setState(() {
      status = filePath != ''
          ? ResourceStatus.downloaded
          : ResourceStatus.readyToDownload;
    });

    if(filePath == ''){
      saveResourcePath(widget.resource, '');
    }
  }
}
