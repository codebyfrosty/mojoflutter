import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ar/provider/order_provider.dart';
import 'package:flutter_ar/screens/cancel_page.dart';
import 'package:flutter_ar/screens/success_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ar/shared/theme.dart';

class DetailPembayaranPage extends StatefulWidget {
  final dynamic paymentDetail;

  const DetailPembayaranPage({Key? key, required this.paymentDetail})
      : super(key: key);

  @override
  State<DetailPembayaranPage> createState() => _DetailPembayaranPageState();
}

class _DetailPembayaranPageState extends State<DetailPembayaranPage> {
  late Timer _timer;
  late String _countdown = '';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final expiryTime = widget.paymentDetail.expiryTime;
      final now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTime);
      final duration = parsedExpiryTime.difference(now);

      if (duration.isNegative) {
        setState(() {
          _countdown = 'Waktu Habis';
        });
        _timer.cancel();
      } else {
        final hours = duration.inHours;
        final minutes = duration.inMinutes.remainder(60);
        final seconds = duration.inSeconds.remainder(60);

        setState(() {
          _countdown = '$hours jam $minutes menit $seconds detik';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Metode Pembayaran: ${widget.paymentDetail.paymentMethod}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Pembayaran: ${NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(widget.paymentDetail.grossAmount)}',
              style: const TextStyle(
                fontSize: 18,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Bank: ${widget.paymentDetail.bank}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            Text(
              'No Rek/Virtual Account: ${widget.paymentDetail.vaNumber}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            Text(
              'Bayar Dalam: $_countdown',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            const Text(
              'Peringatan Penting',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Mohon untuk mentransfer pembayaran sebelum jangka waktu yang telah ditentukan untuk transfer bank. Kelewatan dalam pembayaran bisa mengakibatkan gangguan dalam proses transaksi dan dampak negatif pada tujuan akhir transfer. Mohon pastikan Anda mematuhi batas waktu yang telah ditetapkan untuk menghindari kemungkinan masalah tersebut.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              children: [
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .cancelPayment(paymentId: widget.paymentDetail.id)
                          .then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CancelPage(),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      elevation: 0,
                      backgroundColor: Colors.redAccent,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Batalkan'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.paymentDetail.status == 'pending') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Silakan selesaikan pembayaran anda'),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        );
                      } else if (widget.paymentDetail.status == 'success') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SuccessPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pembayaran gagal'),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(190, 50),
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Check Status'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
