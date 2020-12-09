library network_repository;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rxdart/subjects.dart';
import 'package:shop_repository_core/shop_repository_core.dart';

class ReactiveProductsRepositoryImpl extends ReactiveProductsRepository {
  static const productsFirebasePathUrl =
      "https://shop-app-d4584.firebaseio.com/products";

  final BehaviorSubject<List<ProductEntity>> _productsSubject;
  bool _loaded = false;

  String _creatorId,
      _token; // Todo: Look into dependency injection for these fields

  ReactiveProductsRepositoryImpl(this._creatorId, this._token)
      : _productsSubject = BehaviorSubject();

  @override
  Future<void> addNewProduct(ProductEntity product) async {
    try {
      product.creatorId = _creatorId;
      final response = await post(
        "$productsFirebasePathUrl/.json?auth=$_token",
        body: product.toJson(),
      );

      var newProd = product.copy(
        id: json.decode(response.body)['name'],
      );

      _productsSubject.add([newProd, ..._productsSubject.value]);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response =
        await delete("$productsFirebasePathUrl/$id.json?auth=$_token");
    if (response.statusCode >= 400) {
      throw HttpException("Could not delete product");
    } else
      _productsSubject.add(
          _productsSubject.value..removeWhere((element) => element.id == id));
  }

  @override
  Stream<List<ProductEntity>> get allProducts {
    if (!_loaded) _loadProducts();

    return _productsSubject.stream;
  }

  @override
  Stream<List<ProductEntity>> get userProducts {
    if (!_loaded) _loadProducts();

    return _productsSubject.stream.map(
        (event) => event.where((element) => element.creatorId == _creatorId));
  }

  void _loadProducts() async {
    _loaded = true;

    // Ideally, error handling should be here
    try {
      var response = await get(
        "$productsFirebasePathUrl/.json?auth=$_token",
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      List<ProductEntity> loadedProducts = [];
      if (data == null) return;

      final productFavoriteData = await get(
          "https://shop-app-d4584.firebaseio.com/userFavorites/$_creatorId.json?auth=$_token");
      final favData =
          json.decode(productFavoriteData.body) as Map<String, dynamic>;

      data.forEach((id, prodData) {
        // loadedProducts.add(ProductEntity(
        //   id: id,
        //   title: prodData['title'],
        //   description: prodData['description'],
        //   price: prodData['price'],
        //   isFavorite: favData == null ? false : favData[id] ?? false,
        //   imageUrl: prodData['imageUrl'],
        // ));
        loadedProducts.add(ProductEntity.fromJson(prodData).copy(
            id: id,
            isFavorite: favData == null ? false : favData[id] ?? false));
      });

      _productsSubject.add(loadedProducts);
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    var idx = _productsSubject.value
        .indexWhere((element) => element.id == product.id);
    if (idx >= 0) {
      var newProd = product.copy(id: product.id)..creatorId = _creatorId;
      patch("$productsFirebasePathUrl/${product.id}.json?auth=$_token",
          body: newProd.toJson());

      _productsSubject.add(_productsSubject.value..[idx] = newProd);
    }
  }
}
