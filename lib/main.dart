import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_editor_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import 'providers/auth.dart';
import 'providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, previousOrders) =>
              previousOrders..setToken(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(),
            update: (_, auth, previousProducts) {
              return previousProducts
                ..setToken(auth.token)
                ..setUserId(auth.userId);
            }),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                title: 'MyShop',
                theme: ThemeData(
                    fontFamily: 'Lato',
                    primarySwatch: Colors.purple,
                    accentColor: Colors.deepOrange),
                home: auth.isAuthenticated
                    ? ProductsOverviewScreen()
                    : AuthScreen(),
                routes: {
                  ProductDetailsScreen.routeName: (ctx) =>
                      ProductDetailsScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                  ProductEditorScreen.routeName: (ctx) => ProductEditorScreen(),
                  AuthScreen.routeName: (ctx) => AuthScreen(),
                },
              )),
    );
  }
}
