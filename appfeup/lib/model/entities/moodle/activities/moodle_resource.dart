import 'package:uni/model/entities/moodle/moodle_activity.dart';

import '../../../utils/moodle_activity_type.dart';


class MoodleResource extends MoodleActivity {
  String filePath = '';
  final String fileURL;

  MoodleResource(int id, String title,
      {this.filePath, this.fileURL, order})
      : super(id, title, MoodleActivityType.resource,
      order: order);


  static MoodleResource fromMap(Map<String, dynamic> map) {
    return MoodleResource(
      map['id'],
      map['title'],
      filePath: map['file_path'],
      fileURL: map['file_url'],
      order: map['orderedBy'],

    );
  }

  @override
  Map<String, dynamic> toMap(int sectionId) {
    final Map<String, dynamic> map = super.toMap(sectionId);
    map.addAll({
      'file_path': filePath,
      'file_url': fileURL
    });
    return map;
  }
}
