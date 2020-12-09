import 'dart:convert';

import 'package:flutter/material.dart';

class Product {
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

  // toggleFavoriteStatus(Auth auth) async {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  //   try {
  //     final response = await put(
  //         "https://shop-app-d4584.firebaseio.com/userFavorites/${auth.userId}/$id.json?auth=${auth.token}",
  //         body: json.encode(isFavorite));
  //     if (response.statusCode >= 400)
  //       throw HttpException("Unable to toggle favorite status");
  //   } catch (error) {
  //     isFavorite = !isFavorite; //Revert optimistic change
  //     notifyListeners();
  //   }
  // }

  String toJsonForUpload(String userId) => json.encode({
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'price': price,
    'creatorId': userId,
  });
}
