import 'package:flutter/material.dart';
import 'package:flutter_ar/screens/login_page.dart';
import 'package:flutter_ar/screens/register_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../shared/settings_card.dart';
import '../shared/theme.dart';

class NotLoginPage extends StatelessWidget {
  const NotLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget top() {
      return Column(
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profil1.png'),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'User',
            style: boldTextStyle.copyWith(fontSize: 20),
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      );
    }

    Widget body() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                imagePath: 'assets/images/pesanansaya.png',
                text: 'Daftar',
                onPressed: () {
                  pushNewScreen(context,
                      screen: const RegisterPage(), withNavBar: false);
                }),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/editprofile.png',
                text: 'Login',
                onPressed: () {
                  pushNewScreen(context,
                      screen: const LoginPage(), withNavBar: false);
                }),
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
          'Profile',
          style: boldTextStyle.copyWith(fontSize: 24),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          top(),
          const SizedBox(
            height: 15,
          ),
          body(),
        ],
      ),
    );
  }
}
