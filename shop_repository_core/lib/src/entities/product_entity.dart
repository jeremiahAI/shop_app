class ProductEntity {
  final String id, title, description, imageUrl;
  final double price;
  bool isFavorite;

  ProductEntity({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.price,
    this.isFavorite = false,
  });
}
