class Product {
  String name;
  String price;
  String description;
  String image;
  List availableColours;
  Product(String name, String price, String description, String image, List availableColours) {
    this.name = name;
    this.price = price;
    this.description = description;
    this.image = image;
    this.availableColours = availableColours;
  }
}