import 'package:json_annotation/json_annotation.dart';

part 'product_entity.g.dart';

@JsonSerializable()
class ProductEntity {
  @JsonKey(ignore: true)
  final String id;

  final String title, description, imageUrl;
  final double price;
  String creatorId;

  @JsonKey(ignore: true)
  bool isFavorite;

  ProductEntity({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.price,
    this.isFavorite = false,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProductEntityToJson(this);

  ProductEntity copy(
          {String id, title, description, imageUrl, price, bool isFavorite}) =>
      ProductEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        price: price ?? this.price,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}
