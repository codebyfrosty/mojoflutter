import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      return Container(
        height: MediaQuery.of(context).size.height / 2.3,
        child: Center(
            child: Text(
          'Selamat datang \ndi Mojopahit Furniture',
          style: boldTextStyle.copyWith(fontSize: 24),
          textAlign: TextAlign.center,
        )),
      );

      // Column(
      //   children: [
      //     const Center(
      //       child: CircleAvatar(
      //         radius: 50,
      //         backgroundImage: AssetImage('assets/images/profil1.png'),
      //       ),
      //     ),
      //     const SizedBox(
      //       height: 15,
      //     ),
      //     Text(
      //       'User',
      //       style: boldTextStyle.copyWith(fontSize: 20),
      //     ),
      //     const SizedBox(
      //       height: 4,
      //     ),
      //   ],
      // );
    }

    Widget body() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: FilledButton(
                onPressed: () {
                  pushNewScreen(context,
                      screen: const RegisterPage(), withNavBar: false);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  fixedSize: const Size(290, 50),
                ),
                child: Text(
                  'Daftar',
                  style: boldTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  color: Colors.black12,
                  thickness: 2,
                )),
                Container(
                  child: Text(
                    'Atau',
                    style: TextStyle(color: Colors.grey),
                  ),
                  margin: EdgeInsets.all(10),
                ),
                Expanded(
                    child: Divider(
                  color: Colors.black12,
                  thickness: 2,
                )),
              ],
            ),

            Center(
              child: FilledButton(
                onPressed: () {
                  pushNewScreen(context,
                      screen: const LoginPage(), withNavBar: false);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  fixedSize: const Size(290, 50),
                ),
                child: Text(
                  'Masuk',
                  style: boldTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),
            // SettingsCard(
            //     imagePath: 'assets/images/pesanansaya.png',
            //     text: 'Daftar',
            //     onPressed: () {
            //       pushNewScreen(context,
            //           screen: const RegisterPage(), withNavBar: false);
            //     }),
            // const SizedBox(
            //   height: 15,
            // ),
            // SettingsCard(
            //     imagePath: 'assets/images/editprofile.png',
            //     text: 'Login',
            //     onPressed: () {
            //       pushNewScreen(context,
            //           screen: const LoginPage(), withNavBar: false);
            //     }),
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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        //   color: Colors.black,
        // ),
        backgroundColor: Colors.transparent,
        // title: Text(
        //   'Profile',
        //   style: boldTextStyle.copyWith(fontSize: 24),
        // ),
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
