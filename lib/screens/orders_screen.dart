import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    //  We can use of(context) here because we're not listening. If we were listening, we'd have had to use a Future.delayed.. or worked with didChangeDependencies and tracking if the page is loaded
    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .then((value) => setState(() => _isLoading = false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Orders>(
              builder: (_, ordersData, child) => ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (BuildContext context, int index) =>
                    OrderItemWidget(order: ordersData.orders[index]),
              ),
            ),
    );
  }
}
