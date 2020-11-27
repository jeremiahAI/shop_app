import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final Auth auth = Provider.of<Auth>(context, listen: false);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(ProductDetailsScreen.routeName, arguments: product),
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('../images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer<Product>(
              builder: (_, product, child) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () => product.toggleFavoriteStatus(auth),
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                  // product.isFavorite ?
                  Icons.shopping_cart
                  // : Icons.shopping_cart_outlined,
                  ),
              onPressed: () {
                cart.addItem(product);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(product.title + " added to cart"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () => cart.removeSingleItem(product),
                  ),
                ));
              },
              color: Theme.of(context).accentColor,
            ),
            // subtitle: Text(product.description),
          ),
        ),
      ),
    );
  }
}
