import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/provider/order_provider.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:provider/provider.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<OrderProvider>(context, listen: false).fetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Pesanan Saya',
          style: boldTextStyle,
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.orderStatus == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (orderProvider.orderStatus == OrderStatus.error) {
            return const Center(child: Text('Error loading orders'));
          } else if (orderProvider.orderStatus == OrderStatus.empty) {
            return const Center(child: Text('No orders available'));
          } else if (orderProvider.orderStatus == OrderStatus.success) {
            return ListView.builder(
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];
                return ListTile(
                  title: Text(
                    order.buyyer.name,
                    style: boldTextStyle,
                  ),
                  subtitle: _buildStatusWidget(order.status),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatPrice(order.totalCost.toDouble()),
                        style: mediumTextStyle,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text('Unexpected error');
          }
        },
      ),
    );
  }

  Widget _buildStatusWidget(String status) {
    Color statusColor = Colors.grey;
    String statusText = '';

    if (status == 'delivered') {
      statusColor = Colors.green;
      statusText = 'Delivered';
    } else if (status == 'on_progress') {
      statusColor = Colors.orange;
      statusText = 'On Progress';
    } else if (status == 'failure') {
      statusColor = Colors.red;
      statusText = 'Canceled';
    }

    return Text(
      statusText,
      style: TextStyle(
        color: statusColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
