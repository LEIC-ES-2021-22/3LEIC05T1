class MoodlePageTable {
  final List<List<String>> entries;

  MoodlePageTable(this.entries);

  Map<String, dynamic> toMap(int sectionId, int order){
    return {
      'id_content': sectionId,
      'orderedby': order,
      'type': 'list',
      'ncols': 1,
      'nrows': entries.length,
    };
  }

  @override
  String toString() {
    return 'CourseInfoTable{entries: $entries}';
  }
}