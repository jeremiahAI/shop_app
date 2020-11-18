import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id, title, description, imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  Product copy({String id, title, description, imageUrl, price}) => Product(
        id: id != null ? id : this.id,
        title: title != null ? title : this.title,
        description: description != null ? description : this.description,
        imageUrl: imageUrl != null ? imageUrl : this.imageUrl,
        price: price != null ? price : this.price,
      );

  toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
