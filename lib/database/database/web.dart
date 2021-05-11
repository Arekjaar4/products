import 'package:moor/moor_web.dart';

import '../database_manager.dart';


AppDatabase constructDb({bool logStatements = false}) {
  return AppDatabase(WebDatabase('db', logStatements: logStatements));
}
