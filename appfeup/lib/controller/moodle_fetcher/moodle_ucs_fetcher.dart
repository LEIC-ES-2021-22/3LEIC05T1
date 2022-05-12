import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';

import '../../model/entities/session.dart';

abstract class MoodleUcsFetcher {
  Future<List<int>> getUcs(Session session);
}