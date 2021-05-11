import 'package:moor/moor.dart';
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get price => text()();
  TextColumn get description => text()();
}

@DataClassName('ProductsEntry')
class ProductsEntries extends Table {
  // id of the cart that should contain this item.
  IntColumn get product => integer()();
  // id of the item in this cart
  IntColumn get item => integer()();
// again, we could store additional information like when the item was
// added, an amount, etc.
}