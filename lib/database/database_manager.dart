import 'package:moor/moor.dart';
import 'package:myapp/poduct_with_images.dart';
import 'package:myapp/product.dart';
import 'package:myapp/product_images.dart';
import 'package:rxdart/rxdart.dart';

part 'database_manager.g.dart';


@UseMoor(tables: [Products, ImagesProducts, ProductsEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  // Queries
  // Get all users
  Future<List<Product>> getAllProducts() => select(products).get();

  // Add user
  Future insertProduct(Product product) => into(products).insert(product);

  // Update user
  Future updateProduct(Product product) => update(products).replace(product);

  // Delete user
  Future deleteProduct(Product product) => delete(products).delete(product);

  Future<List<ImagesProduct>> getAllImagesProduct() => select(imagesProducts).get();

  // Add user
  Future insertImagesProduct(ImagesProduct imagesProduct) => into(imagesProducts).insert(imagesProduct);

  // Update user
  Future updateImagesProduct(ImagesProduct imagesProduct) => update(imagesProducts).replace(imagesProduct);

  // Delete user
  Future deleteImagesProduct(ImagesProduct imagesProduct) => delete(imagesProducts).delete(imagesProduct);

  Future<void> writeProduct(ProductWithImages entry) {
    print('entry');
    print(entry);
    return transaction(() async {
      print('transaction');
      final product = entry.product;

      // first, we write the shopping cart
      await into(products).insert(product, mode: InsertMode.replace).then((value) => print('guarda')).onError((error, stackTrace) => print(error));

      // we replace the entries of the cart, so first delete the old ones
      await (delete(productsEntries)
        ..where((entry) => entry.product.equals(product.id)))
          .go();

      // And write the new ones
      for (final item in entry.imagesProduct) {
        await into(productsEntries).insert(ProductsEntry(product: product.id, item: item.id));
      }
    });
  }
  Stream<List<ProductWithImages>> watchAllProducts() {
    // start by watching all carts
    final productStream = select(products).watch();
    //print('watchAllProducts');
    return productStream.switchMap((imagesProduct) {
      print('watchAllProducts');
      // this method is called whenever the list of carts changes. For each
      // cart, now we want to load all the items in it.
      // (we create a map from id to cart here just for performance reasons)
      final idToProduct = {for (var image in imagesProduct) image.id: image};
      final ids = idToProduct.keys;

      // select all entries that are included in any cart that we found
      final entryQuery = select(productsEntries).join(
        [
          innerJoin(
            imagesProducts,
            imagesProducts.id.equalsExp(productsEntries.item),
          )
        ],
      )..where(productsEntries.product.isIn(ids));

      return entryQuery.watch().map((rows) {
        // Store the list of entries for each cart, again using maps for faster
        // lookups.
        final idToItems = <int, List<ImagesProduct>>{};

        // for each entry (row) that is included in a cart, put it in the map
        // of items.
        for (var row in rows) {
          final item = row.readTable(imagesProducts);
          final id = row.readTable(productsEntries).product;

          idToItems.putIfAbsent(id, () => []).add(item);
        }

        // finally, all that's left is to merge the map of carts with the map of
        // entries
        return [
          for (var id in ids)
            ProductWithImages(idToProduct[id], idToItems[id] ?? []),
        ];
      });
    });
  }
}