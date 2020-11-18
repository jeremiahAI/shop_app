import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/products_provider.dart';

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

  toggleFavoriteStatus() async {
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await patch(
          "${Products.productsFirebasePathUrl}/$id.json",
          body: this.toJson());
      if (response.statusCode >= 400)
        throw HttpException("Unable to toggle favorite status");
    } catch (error) {
      isFavorite = !isFavorite; //Revert optimistic change
      notifyListeners();
    }
  }

  String toJson() => json.encode({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'isFavorite': isFavorite,
      });
}
