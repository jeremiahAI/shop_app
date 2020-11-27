import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (_, dataSnapshot) =>
            dataSnapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : dataSnapshot.hasError
                    ? Center(
                        child: Text('An error occurred'),
                      )
                    : Consumer<Orders>(
                        builder: (_, ordersData, child) => ListView.builder(
                          itemCount: ordersData.orders.length,
                          itemBuilder: (BuildContext context, int index) =>
                              OrderItemWidget(order: ordersData.orders[index]),
                        ),
                      ),
      ),
    );
  }
}
