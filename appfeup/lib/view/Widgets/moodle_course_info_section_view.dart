import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page_entities/moodle_page_section_title.dart';
import '../../model/entities/moodle/activities/moodle_page_entities/moodle_page_list.dart';
import '../../model/entities/moodle/activities/moodle_page_entities/moodle_page_section.dart';
import '../../model/entities/moodle/activities/moodle_page_entities/moodle_page_table.dart';

class MoodleCourseInfoSection extends StatefulWidget {
  final MoodlePageSection moodlePageSection;

  MoodleCourseInfoSection(this.moodlePageSection, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MoodleCourseInfoSectionState(this.moodlePageSection);
  }

  /*Widget buildContent(BuildContext context) {
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
  }*/
}

class MoodleCourseInfoSectionState extends State<MoodleCourseInfoSection> {
  final double borderRadius = 10.0;
  final double padding = 12.0;

  final MoodlePageSection moodlePageSection;

  MoodleCourseInfoSectionState(this.moodlePageSection);

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [createTitle(context)] + createContent(context));
  }

  Widget createTitle(BuildContext context) {
    return  Container(
      child: Text(this.moodlePageSection.title.text,
          style: Theme.of(context).textTheme.headline6.apply(
              fontSizeFactor: 1.3,
              color: Color.fromARGB(255, 0x75, 0x17, 0x1e))),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(top: 8, bottom: 10),
    );
  }

  List<Widget> createContent(BuildContext context) {
    final List<Widget> widgets = [];
    this.moodlePageSection.content.forEach((element) {
      if (element is String) {
        widgets.add(
            Container(
              child: Text(element,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .apply(fontSizeFactor: 0.8)),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.only(bottom: 8),
            ),
        );
      } else if (element is MoodlePageList) {
        element.entries.forEach((entry) {
          widgets.add(Container(
                child: Text("\u2022 " + entry,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .apply(fontSizeFactor: 0.8)),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.only(bottom: 8),
              ),
          );
        });
      } else if (element is MoodlePageTable) {
          widgets.add(
            Padding(
              padding: EdgeInsets.all(10),
             child: Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: createTableRows(context, element),

        )
            )
          );
      } else if (element is MoodlePageSectionTitle){
        widgets.add(Container());
      }
    });
    return widgets;
  }
  List<TableRow> createTableRows(BuildContext context, MoodlePageTable moodlePageTable)
  {
    List<TableRow> tableRows = [];

    moodlePageTable.entries.forEach((row) {
      tableRows.add( TableRow(
        children:
          createTableCells(context, row)
      ));
    });

    return tableRows;
  }

  List<Widget> createTableCells(BuildContext context, List<String> row)
  {
    final List<Widget> widgets = [];

    row.forEach((value) {
      widgets.add(
          Container(
            padding: EdgeInsets.all(5),
          child: Text(value)

      ));
    });

    return widgets;
  }

}

