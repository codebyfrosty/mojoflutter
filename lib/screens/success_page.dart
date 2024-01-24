import 'package:flutter/material.dart';
import 'package:flutter_ar/shared/theme.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 120),
            Text('Pembayaran Sukses!',
                style: boldTextStyle.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            Text(
              'Pesanan Anda telah berhasil\ndiproses dan segera dikirimkan kepada Anda',
              textAlign: TextAlign.center,
              style: regularTextStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/main');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      fixedSize: const Size(340, 50),
                    ),
                    child: Text(
                      'Lanjutkan',
                      style: boldTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // FilledButton(
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, '/main');
                  //   },
                  //   style: FilledButton.styleFrom(
                  //     backgroundColor: Colors.white,
                  //     side: const BorderSide(color: primaryColor),
                  //     fixedSize: const Size(340, 50),
                  //   ),
                  //   child: Text(
                  //     'Batal',
                  //     style: boldTextStyle.copyWith(
                  //         color: primaryColor,
                  //         fontWeight: FontWeight.w700,
                  //         fontSize: 20),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
