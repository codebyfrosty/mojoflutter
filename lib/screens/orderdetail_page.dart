import 'package:flutter/material.dart';
import 'package:flutter_ar/model/orderdetail_model.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderDetail orderDetail;

  const OrderDetailScreen({Key? key, required this.orderDetail})
      : super(key: key);

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
          'Detail Order',
          style: getTextStyle(isBold: true, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order ID:'),
                      Text('${orderDetail.id}'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status:'),
                      Text('${orderDetail.status}'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Alamat pengiriman:'),
                      Text(
                        '${orderDetail.destinationAddress}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Courier:'),
                      Text('${orderDetail.courierCompanyName}'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping Cost:'),
                      Text('Rp. ${orderDetail.shippingCost}'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Payment:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp. ${orderDetail.totalCost}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Order Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderDetail.orderItems.length,
              itemBuilder: (context, index) {
                final item = orderDetail.orderItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        item.image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'qty x${item.quantity} Rp.${item.price}',
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Total : Rp.${item.quantity * item.price}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text('Histori Pengiriman:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderDetail.orderHistory.length,
              itemBuilder: (context, index) {
                final history = orderDetail.orderHistory[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(history.status,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(history.note),
                              SizedBox(height: 5),
                              Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(history.updatedAt)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
