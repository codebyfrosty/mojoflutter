import 'package:flutter/material.dart';
import 'package:flutter_ar/shared/theme.dart';

class CancelPage extends StatelessWidget {
  const CancelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cancel_rounded, color: Colors.red, size: 120),
            Text('Pesanan Dibatalkan!',
                style: boldTextStyle.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            Text(
              'Pesanan Anda telah dibatalkan\nsilahkan pesan kembali jika ingin memesan lagi.',
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
                      'Kembali Berbelanja',
                      style: boldTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
