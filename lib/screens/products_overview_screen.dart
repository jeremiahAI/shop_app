import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: ProductsGridWidget(),
    );
  }
}

class ProductsGridWidget extends StatelessWidget {
  const ProductsGridWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;

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
