import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class CartItem {
  final String id, title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

  static CartItem fromProduct(Product product, {int quantity = 1}) => CartItem(
      id: product.id,
      title: product.title,
      quantity: quantity,
      price: product.price);
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.entries.fold(
      0, (previousValue, element) => previousValue + element.value.quantity);

  double get totalAmount => _items.entries.fold(
      0,
      (previousValue, element) =>
          previousValue + (element.value.price * element.value.quantity));

  void addItem(Product product) {
    _items.containsKey(product.id)
        ? _items.update(
            product.id,
            (existingCartItem) => CartItem.fromProduct(product,
                quantity: existingCartItem.quantity + 1))
        : _items.putIfAbsent(product.id, () => CartItem.fromProduct(product));
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
