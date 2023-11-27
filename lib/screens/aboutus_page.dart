import 'package:flutter/material.dart';

import '../shared/theme.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
          color: Colors.black,
        ),
        title: Text(
          'Tentang Kami',
          style: boldTextStyle,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Selamat Datang\ndi Toko Mojopahit Furniture',
                  style: boldTextStyle.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24,
                ),
                Image.asset('assets/images/tentangkami.png'),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Temukan keindahan dan kenyamanan di rumah Anda dengan koleksi eksklusif dari Toko Mojopahit Furniture! Dari gaya klasik yang elegan hingga desain modern yang minimalis, kami memiliki pilihan furniture terbaik untuk memenuhi segala kebutuhan dekorasi rumah Anda. Dibuat dengan kualitas terbaik dan sentuhan kerajinan tangan, setiap potongan furniture kami adalah karya seni yang akan menghadirkan suasana hangat dan memikat di setiap ruangan. Kunjungi toko kami dan temukan inspirasi baru untuk mengubah rumah Anda menjadi tempat yang sempurna untuk bersantai dan merayakan keindahan hidup.',
                  style: regularTextStyle.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
