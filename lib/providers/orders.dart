import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        Order(
            id: DateTime.now().toString(),
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
