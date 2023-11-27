import 'package:flutter/material.dart';
import 'package:flutter_ar/screens/aboutus_page.dart';
import 'package:flutter_ar/screens/changepass_page.dart';
import 'package:flutter_ar/screens/edit_page.dart';
import 'package:flutter_ar/shared/settings_card.dart';

import '../shared/theme.dart';

class PesananSayaPage extends StatelessWidget {
  const PesananSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget body() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: boldTextStyle.copyWith(color: Colors.grey),
            ),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/belumbayar.png',
                text: 'Belum Bayar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PesananSayaPage(),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/sedangdibuat.png',
                text: 'Sedang dikemas atau dibuat',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/sedangdikirim.png',
                text: 'Sedang dikirim',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePassPage(),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/selesai.png',
                text: 'Selesai',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsPage(),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/batal.png',
                text: 'Batal',
                onPressed: () {}),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      );
    }

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
          'Pesanan Saya',
          style: boldTextStyle.copyWith(fontSize: 24),
        ),
      ),
      body: body(),
    );
  }
}
