import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

import 'product_item.dart';

class ProductsGridWidget extends StatelessWidget {
  final bool showOnlyFaves;

  const ProductsGridWidget(this.showOnlyFaves, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showOnlyFaves ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(
                // products[index],
                ));
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 5 / 4),
      itemCount: products.length,
      padding: const EdgeInsets.all(10),
    );
  }
}
