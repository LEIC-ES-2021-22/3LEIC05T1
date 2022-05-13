class Section {
  int id;
  String title;
  String summary;
  String activity;
  //List<Activity>

  Section(this.id, this.title, this.summary, this.activity);

  static Section fromMap(Map<String, dynamic> map){
    return Section(
      map['id'],
      map['title'],
      map['summary'],
      ''
    );
  }

  Map<String, dynamic> toMap(int unitCourseId){
    return {
      'id' : id,
      'unit_course_id': unitCourseId,
      'title' : title,
      'summary' : summary
    };
  }

}