import 'package:flutter/material.dart';
import 'package:flutter_ar/provider/order_provider.dart';
import 'package:flutter_ar/screens/payment_page.dart';
import 'package:flutter_ar/screens/pendingpaymentdetail_page.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ar/provider/payment_provider.dart';
import 'package:flutter_ar/model/payment_model.dart';

class PendingPaymentScreen extends StatefulWidget {
  const PendingPaymentScreen({Key? key}) : super(key: key);

  @override
  State<PendingPaymentScreen> createState() => _PendingPaymentScreenState();
}

class _PendingPaymentScreenState extends State<PendingPaymentScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<PaymentProvider>(context, listen: false).fetchPayments();
      _isInit = false;
    }
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

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    Future<dynamic> _fetchPaymentDetail(
        String paymentId, BuildContext context) async {
      try {
        final orderProvider =
            Provider.of<PaymentProvider>(context, listen: false);
        final paymentDetail = await orderProvider.fetchPaymentDetail(paymentId);
        return paymentDetail;
      } catch (error) {
        throw Exception('Error fetching payment detail: $error');
      }
    }

    Widget _buildPaymentDetail(BuildContext context, String paymentId) {
      return FutureBuilder<dynamic>(
        future: _fetchPaymentDetail(paymentId, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching payment detail'));
          } else if (snapshot.hasData) {
            final paymentDetail = snapshot.data!;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailPembayaranPage(paymentDetail: paymentDetail),
              ),
            );
            return Container();
          } else {
            return Container();
          }
        },
      );
    }

    void _showPaymentDetail(BuildContext context, String paymentId) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );

      try {
        final paymentDetail = await _fetchPaymentDetail(paymentId, context);

        Navigator.of(context, rootNavigator: true).pop();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPembayaranPage(paymentDetail: paymentDetail),
          ),
        );
      } catch (error) {
        Navigator.of(context, rootNavigator: true).pop();
        print('Error fetching payment detail: $error');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Error fetching payment detail'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

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
          'Menunggu Pembayaran',
          style: getTextStyle(isBold: true, color: Colors.black),
        ),
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, paymentProvider, child) {
          final pendingPayments = paymentProvider.payments.toList();

          if (pendingPayments.isEmpty) {
            return Center(
                child: Text('No pending payments available',
                    style: TextStyle(fontSize: 18)));
          }

          return ListView.builder(
            itemCount: pendingPayments.length,
            itemBuilder: (context, index) {
              final payment = pendingPayments[index];

              return GestureDetector(
                onTap: () {
                  _showPaymentDetail(context, payment.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID : ${payment.orderId}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Divider(
                        thickness: 1.0,
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Payment Due: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(payment.expiryTime)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 164, 33, 33),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Text(
                        'Payment Method: ${payment.bank.toUpperCase()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'No VA: ${payment.vaNumber}',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Text(
                        'Total Order: ${currencyFormat.format(payment.grossAmount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showPaymentDetail(context, payment.id);
                          },
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text(
                            'Detail Pembayaran',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
