import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page_entities/moodle_page_list.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page_entities/moodle_page_section.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page_entities/moodle_page_section_title.dart';
import 'package:uni/model/entities/moodle/activities/moodle_page_entities/moodle_page_table.dart';
import 'package:uni/model/entities/moodle/activities/moodle_resource.dart';
import 'package:uni/model/entities/moodle/activities/moodle_sigarra_course_info.dart';
import 'package:uni/model/entities/moodle/moodle_activity.dart';
import 'package:uni/model/entities/moodle/moodle_section.dart';

import '../app_database.dart';

/**
 * Relative to moodle
 */
class MoodlePageDatabase extends AppDatabase {
  static final String _TABLENAME = 'moodle_pages';

  MoodlePageDatabase()
      : super(_TABLENAME + '.db', [
''' CREATE TABLE ${_TABLENAME}(
      id INTEGER PRIMARY KEY,
      title TEXT
    )
    ''',
''' CREATE TABLE MOODLE_PAGE_SECTIONS(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_page INTEGER,
      orderedby INTEGER,
      type TEXT,
      TITLE TEXT
    )
    ''',
    '''
    CREATE TABLE MOODLE_PAGE_SECTION_OBJECT(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_content INTEGER,
        orderedby INTEGER,
        type TEXT,
        title TEXT,
        heading_nr INTEGER,
        ncols INTEGER,
        nrows INTEGER
    )
    ''',
    '''
    CREATE TABLE MOODLE_PAGE_SECTION_OBJECT_ELEMENT(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_collection INTEGER,
        content TEXT,
        orderedby INTEGER
    )
    '''
        ]);

  Future<List<dynamic>> getPageContent(int pageId) async{
    Database db = await getDatabase();
    List<Map<String, dynamic>> sectionsMap =
      await db.query('MOODLE_PAGE_SECTIONS',
        where: 'id_page = ?', whereArgs: [pageId],
        orderBy: 'orderedby asc');
    final List<MoodlePageSection> sections = [];
    for(Map<String,dynamic> map in sectionsMap){
      MoodlePageSection section = MoodlePageSection(map['title'], await _getSectionContent(db, map['id']));
      sections.add(section);
    }
    return sections;
  }

  Future<List<dynamic>> _getSectionContent(Database db, int sectionId) async{
    //MOODLE_PAGE_SECTION_OBJECT
    List<Map<String, dynamic>> contentsMap =
    await db.query('MOODLE_PAGE_SECTIONS',
        where: 'id_content = ?', whereArgs: [sectionId],
        orderBy: 'orderedby asc');
    final List<dynamic> contents = [];
    for(Map<String,dynamic> map in contentsMap){
      switch(map['type']){
        case 'table':
          contents.add(MoodlePageTable(await _getTableEntries(db, map['id'], map['ncols'], map['rows'])));
          break;
        case 'list':
          contents.add(MoodlePageList(await _getListEntries(db, map['id'])));
          break;
        case 'title':
          contents.add(MoodlePageSectionTitle(map['title'], map['heading_nr']));
          break;
        default:
          Logger().w('getSectionContent in moodle_page_database got a wrong type');
      }
    }
    return contents;
  }

  Future<List<String>> _getListEntries(Database db, int id) async{
    List<Map<String, dynamic>> entriesMap = await db.query('MOODLE_PAGE_SECTION_OBJECT_ELEMENT',
      where: 'id_collection = ? ', whereArgs: [id],
              orderBy: 'orderedby asc');
    return entriesMap.map((map) => map['content'].toString()).toList();
  }

  Future<List<List<String>>> _getTableEntries
      (Database db, int id, int ncols, int nrows) async{
    List<Map<String, dynamic>> entriesMap = await db.query('MOODLE_PAGE_SECTION_OBJECT_ELEMENT',
        where: 'id_collection = ? ', whereArgs: [id],
        orderBy: 'orderedby asc');
    List<String> all = entriesMap.map((map) => map['content'].toString()).toList();
    List<List<String>> list = [];
    for(int i=0;i<nrows;i+=ncols){
      list.add(all.sublist(i, i*ncols));
    }
    return list;
  }

  Future<void> deleteAll() async{
    Database db = await getDatabase();
    db.transaction((txn) async {
        txn.delete(_TABLENAME);
        txn.delete('MOODLE_PAGE_SECTIONS');
        txn.delete('MOODLE_PAGE_SECTION_OBJECT');
        txn.delete('MOODLE_PAGE_SECTION_OBJECT_ELEMENT');
      }
    );

  }

  Future<void> savePage(PageActivity page) async {
    Database db = await getDatabase();
    db.transaction((txn) async{
      txn.insert(_TABLENAME,
          {
            'id': page.id,
            'title': page.title
          }
      );
      int order = 0;
      for(MoodlePageSection pageSection in page.content){
        _savePageSection(pageSection, txn, order++);
      }
    });
  }

  Future<void> saveSigarraPage(SigarraCourseInfo page) async {
    Database db = await getDatabase();
    db.transaction((txn) async{
      txn.insert(_TABLENAME,
          {
            'id': page.id,
            'title': page.title
          }
      );
      int order = 0;
      for(MoodlePageSection pageSection in page.content){
        _savePageSection(pageSection, txn, order++);
      }
    });
  }

  Future<void> _savePageSection(MoodlePageSection pageSection, Transaction txn,
      int order) async {
    int id = await txn.insert('MOODLE_PAGE_SECTIONS', pageSection.toMap(order));
    int contentOrder = 0;
    for(dynamic content in pageSection.content){
      if(content is MoodlePageList){
        _saveList(content, txn, id, contentOrder);
      } else if( content is MoodlePageTable){
        _saveTable(content, txn, id, contentOrder);
      } else if(content is MoodlePageSectionTitle){
        _saveTitle(content, txn, id, contentOrder);
      } else {
        Logger().w('Page section content unkown ' + content.toString());
      }
      contentOrder++;
    }
  }

  Future<void> _saveList(MoodlePageList list, Transaction txn, int sectionId, int order) async{
    int id = await txn.insert('MOODLE_PAGE_SECTION_OBJECT', list.toMap(sectionId, order));
    int entryOrder = 0;
    for(String entry in list.entries){
      await txn.insert('MOODLE_PAGE_SECTION_OBJECT_ELEMENT',
          {
            'id_collection': id,
            'content': entry,
            'order': entryOrder++
          });
    }
  }

  Future<void> _saveTable(MoodlePageTable table, Transaction txn, int sectionId, int order) async{
    int id = await txn.insert('MOODLE_PAGE_SECTION_OBJECT', table.toMap(sectionId, order));
    int entryOrder = 0;
    for(List<String> row in table.entries){
      for(String entry in row){
        await txn.insert('MOODLE_PAGE_SECTION_OBJECT_ELEMENT',
            {
              'id_collection': id,
              'content': entry,
              'order': entryOrder++
            });
      }
    }
  }

  Future<void> _saveTitle(MoodlePageSectionTitle title, Transaction txn, int sectionId, int order) async{
    await txn.insert('MOODLE_PAGE_SECTION_OBJECT', title.toMap(sectionId, order));
  }
}
