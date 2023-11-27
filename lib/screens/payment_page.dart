import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ar/provider/order_provider.dart';
import 'package:flutter_ar/screens/cancel_page.dart';
import 'package:flutter_ar/screens/success_page.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  Timer? _countdownTimer;
  DateTime expiryTime = DateTime.now();
  Duration _countdownDuration = Duration.zero;
  String _countdownFormatted = '';

  @override
  void initState() {
    super.initState();

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final createdOrderData = orderProvider.createdOrderData;

    if (createdOrderData != null) {
      final rawExpiryTime = createdOrderData['expiry_time'];
      final expiryTime = DateTime.parse(rawExpiryTime).toLocal();
      final currentTime = DateTime.now();
      _countdownDuration = expiryTime.difference(currentTime);

      _formatCountdownDuration();
      _startCountdownTimer();
    }
  }

  void _formatCountdownDuration() {
    final hours = _countdownDuration.inHours;
    final minutes = _countdownDuration.inMinutes.remainder(60);
    final seconds = _countdownDuration.inSeconds.remainder(60);

    _countdownFormatted = '$hours jam $minutes menit $seconds detik';
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdownDuration = _countdownDuration - const Duration(seconds: 1);

      if (_countdownDuration.isNegative) {
        _countdownFormatted = 'Waktu Habis';
        _countdownTimer?.cancel();
      } else {
        _formatCountdownDuration();
      }

      setState(() {}); // Update the UI
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'Pembayaran',
          style: boldTextStyle.copyWith(fontSize: 24),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final createdOrderData = orderProvider.createdOrderData;
          if (createdOrderData != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text('Metode Pembayaran: '),
                      const Spacer(),
                      Text(
                        'Transfer Bank',
                        style: boldTextStyle.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text('Total Pembayaran: '),
                      const Spacer(),
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID', // Use 'en_US' for English locale
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(createdOrderData['gross_amount']),
                        style: boldTextStyle.copyWith(
                            fontSize: 18, color: primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text('Bank:  '),
                      const Spacer(),
                      Text('${createdOrderData['bank']}'),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text('No Rek/Virtual Account: '),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${createdOrderData['va_number']}',
                        style: mediumTextStyle.copyWith(fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: createdOrderData['va_number']));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to clipboard'),
                              backgroundColor: primaryColor,
                            ),
                          );
                        },
                        child: const Icon(Icons.copy, color: primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text('Bayar Dalam: '),
                      Text(
                        '$_countdownFormatted',
                        style: regularTextStyle.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Peringatan Penting',
                    style: mediumTextStyle.copyWith(letterSpacing: 0.3),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Mohon untuk mentransfer pembayaran sebelum jangka waktu yang telah ditentukan untuk transfer bank. Kelewatan dalam pembayaran bisa mengakibatkan gangguan dalam proses transaksi dan dampak negatif pada tujuan akhir transfer. Mohon pastikan Anda mematuhi batas waktu yang telah ditetapkan untuk menghindari kemungkinan masalah tersebut.',
                    style: regularTextStyle.copyWith(letterSpacing: 0.3),
                  ),
                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Provider.of<OrderProvider>(context,
                                        listen: false)
                                    .cancelPayment(
                                        paymentId: createdOrderData['id'])
                                    .then((value) => pushNewScreen(context,
                                        screen: const CancelPage(),
                                        withNavBar: true));
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(190, 50),
                                  elevation: 0,
                                  backgroundColor: Colors.redAccent,
                                  shape:
                                      const StadiumBorder() // Change button color as needed
                                  ),
                              child: const Text('Batalkan Pembayaran'),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (createdOrderData['status'] == 'pending') {
                                  // show snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Silakan selesaikan pembayaran anda'),
                                      backgroundColor: primaryColor,
                                    ),
                                  );
                                } else if (createdOrderData['status'] ==
                                    'success') {
                                  pushNewScreen(context,
                                      screen: const SuccessPage());
                                } else {
                                  // show snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Pembayaran gagal'),
                                      backgroundColor: primaryColor,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(190, 50),
                                  elevation: 0,
                                  backgroundColor: primaryColor,
                                  shape:
                                      const StadiumBorder() // Change button color as needed
                                  ),
                              child: const Text('Status Pembayaran'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No order data available'),
            );
          }
        },
      ),
    );
  }
}
