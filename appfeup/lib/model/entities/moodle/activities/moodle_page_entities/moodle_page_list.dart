class MoodlePageList {
  final List<String> entries;

  MoodlePageList(this.entries);


  Map<String, dynamic> toMap(int sectionId, int order){
    final int nrows = entries == null ? 0 : entries.length;
    final int ncols = nrows == 0 ? 0 : entries[0].length;
    return {
      'id_content': sectionId,
      'orderedby': order,
      'type': 'list',
      'ncols': ncols,
      'nrows': nrows,
    };
  }

  @override
  String toString() {
    return 'CourseInfoList{entries: $entries}';
  }
}