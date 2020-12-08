import 'package:flutter/material.dart';

import 'cart_item_entity.dart';

class OrderEntity {
  final String id;
  final double amount;
  final List<CartItemEntity> products;
  final DateTime dateTime;

  OrderEntity({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
