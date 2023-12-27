import 'package:flutter/material.dart';
import 'package:flutter_ar/model/order_model.dart';
import 'package:flutter_ar/model/orderdetail_model.dart';
import 'package:flutter_ar/provider/order_provider.dart';
import 'package:flutter_ar/provider/orderdetail_provider.dart';
import 'package:flutter_ar/screens/orderdetail_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:intl/intl.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  String _filterStatus = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
    );
  }

  TextStyle getTextStyle({
    bool isBold = false,
    bool isLight = false,
    Color? color,
  }) {
    if (isBold) {
      return TextStyle(
        fontWeight: FontWeight.bold,
        color: color,
      );
    } else if (isLight) {
      return TextStyle(
        color: color ?? Colors.grey,
      );
    }
    return TextStyle(color: color);
  }

  List<OrderModel> _getFilteredOrders(List<OrderModel> orders) {
    if (_filterStatus.isEmpty) {
      return orders;
    } else {
      return orders.where((order) => order.status == _filterStatus).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

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
          style: getTextStyle(isBold: true, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterButton('ALL', ''),
                _buildFilterButton('On Progress', 'on_progress'),
                _buildFilterButton('Confirmed', 'confirmed'),
                _buildFilterButton('Delivered', 'delivered'),
                _buildFilterButton('Allocated', 'allocated'),
                _buildFilterButton('On Delivery', 'on_delivery'),
                _buildFilterButton('Canceled', 'failure'),
              ],
            ),
          ),
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                if (orderProvider.orderStatus == OrderStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (orderProvider.orderStatus == OrderStatus.error) {
                  return const Center(child: Text('Error loading orders'));
                } else if (orderProvider.orderStatus == OrderStatus.empty) {
                  return const Center(child: Text('No orders available'));
                } else if (orderProvider.orderStatus == OrderStatus.success) {
                  final filteredOrders =
                      _getFilteredOrders(orderProvider.orders);
                  return ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () async {
                              OrderDetailProvider orderDetailProvider =
                                  Provider.of<OrderDetailProvider>(context,
                                      listen: false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FutureBuilder<OrderDetail?>(
                                    future: orderDetailProvider
                                        .fetchOrderDetail(order.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
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
                                              'Order Detail',
                                              style: getTextStyle(
                                                  isBold: true,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          body: const Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                              'Failed to fetch order details.'),
                                        );
                                      } else if (snapshot.hasData) {
                                        final orderDetail = snapshot.data!;
                                        return OrderDetailScreen(
                                            orderDetail: orderDetail);
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${order.createdAt.day}-${order.createdAt.month}-${order.createdAt.year}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                            _buildStatusWidget(order.status),
                                          ],
                                        ),
                                        const SizedBox(height: 12.0),
                                        Text(
                                          'Order ID : ${order.id}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 12.0),
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                order.orderItems[0].image,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 12.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${order.orderItems[0].name}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12.0),
                                                  Text(
                                                    'Qty x${order.orderItems[0].quantity}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4.0),
                                                  Text(
                                                    '${currencyFormat.format(order.orderItems[0].price)},-',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12.0),
                                        const Divider(
                                            color: Color.fromARGB(
                                                255, 224, 224, 224)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Jumlah produk : ${order.totalQuantity}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'Shopping Total ${currencyFormat.format(order.totalCost)},-',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                } else {
                  return const Text('Unexpected error');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, String status) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _filterStatus = status;
        });
      },
      child: Text(text),
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
    } else if (status == 'on_delivery') {
      statusColor = Colors.orange;
      statusText = 'On Delivery';
    } else if (status == 'allocated') {
      statusColor = Colors.orange;
      statusText = 'Allocated';
    } else if (status == 'confirmed') {
      statusColor = Colors.orange;
      statusText = 'Confirmed';
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
