import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/cart.dart';

class Orders with ChangeNotifier {
  static const ordersFirebasePathUrl =
      "https://shop-app-d4584.firebaseio.com/orders";
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  String _token;

  setToken(String token) {
    this._token = token;
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var order = Order(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now());

    final response = await post("$ordersFirebasePathUrl.json?auth=$_token",
        body: order.toJson());

    _orders.insert(0, order.copy(id: json.decode(response.body)['name']));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    // Ideally, error handling should be here
    // try {
    var response = await get(
      "$ordersFirebasePathUrl/.json?auth=$_token",
    );
    final data = json.decode(response.body) as Map<String, dynamic>;
    List<Order> loadedOrders = [];

    if (data != null) {
      data.forEach((id, ordersData) {
        loadedOrders.add(Order(
          id: id,
          amount: ordersData['amount'],
          dateTime: DateTime.parse(ordersData['dateTime']),
          products: (ordersData['products'] as List<dynamic>)
              .map((element) => CartItem(
                  id: element['id'],
                  title: element['title'],
                  quantity: element['quantity'],
                  price: element['price']))
              .toList(),
        ));
      });
    }

    _orders = loadedOrders;
    notifyListeners();
    // } catch (error) {
    //   throw error;
    // }
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

  String toJson() => json.encode({
        'amount': amount,
        'products': products
            .map((CartItem cartItem) => {
                  "id": cartItem.id,
                  "title": cartItem.title,
                  "quantity": cartItem.quantity,
                  "price": cartItem.price,
                })
            .toList(),
        'dateTime': dateTime.toIso8601String(),
      });

  Order copy({String id, amount, products, dateTime, price}) => Order(
      id: id != null ? id : this.id,
      amount: amount != null ? amount : this.amount,
      products: products != null ? products : this.products,
      dateTime: dateTime != null ? dateTime : this.dateTime);
}
