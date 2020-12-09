// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductEntity _$ProductEntityFromJson(Map<String, dynamic> json) {
  return ProductEntity(
    title: json['title'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String,
    price: (json['price'] as num)?.toDouble(),
  )..creatorId = json['creatorId'] as String;
}

Map<String, dynamic> _$ProductEntityToJson(ProductEntity instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'creatorId': instance.creatorId,
    };
