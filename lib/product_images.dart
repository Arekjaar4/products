
import 'package:moor/moor.dart';

class ImagesProducts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get image => text()();
}