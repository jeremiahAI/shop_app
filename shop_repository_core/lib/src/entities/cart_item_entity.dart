import 'package:flutter/material.dart';

class CartItemEntity {
  final String id, title;
  final int quantity;
  final double price;

  CartItemEntity({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          quantity == other.quantity &&
          price == other.price;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ quantity.hashCode ^ price.hashCode;
}
