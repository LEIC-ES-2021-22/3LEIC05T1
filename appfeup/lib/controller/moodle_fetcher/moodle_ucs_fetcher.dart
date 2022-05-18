import 'package:uni/model/entities/session.dart';



abstract class MoodleUcsFetcher {
  Future<List<int>> getUcs(Session session);
}