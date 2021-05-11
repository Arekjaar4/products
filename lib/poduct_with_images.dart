import 'database/database_manager.dart';

class ProductWithImages {
  final Product product;
  final List<ImagesProduct> imagesProduct;

  ProductWithImages(this.product, this.imagesProduct);
}