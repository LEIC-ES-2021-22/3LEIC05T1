class MoodleModule {
  int id;
  String title;
  String type;
  String description;


  MoodleModule(this.id, this.title, this.type, {this.description = ''});

  static MoodleModule fromMap(Map<String, dynamic> map){
    return MoodleModule(
        map['id'],
        map['title'],
        map['type'],
        description: map['description']?? '',
    );
  }

  Map<String, dynamic> toMap(int sectionId){
    return {
      'id' : id,
      'section_id': sectionId,
      'title' : title,
      'type' : type,
      'description' : description
    };
  }
}