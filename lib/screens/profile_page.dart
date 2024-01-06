import 'package:flutter/material.dart';
import 'package:flutter_ar/screens/aboutus_page.dart';
import 'package:flutter_ar/screens/bottom_navigation_bar.dart';
import 'package:flutter_ar/screens/changepass_page.dart';
import 'package:flutter_ar/screens/edit_page.dart';
import 'package:flutter_ar/screens/login_page.dart';
import 'package:flutter_ar/screens/notlogin_page.dart';
import 'package:flutter_ar/screens/orderlist_page.dart';
import 'package:flutter_ar/screens/pendingpayment_page.dart';
import 'package:flutter_ar/shared/settings_card.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/api.dart';
import '../provider/auth_provider.dart';
import '../provider/user_provider.dart';
import 'listaddress_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UserProfileProvider>(context, listen: false)
            .fetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    Widget top() {
      return Consumer<UserProfileProvider>(builder: (context, data, child) {
        if (data.state == UserProfileState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.state == UserProfileState.Error) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          return Center(
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        data.userProfile!.profilePicture.url,
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  data.userProfile!.name,
                  style: boldTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  data.userProfile!.email,
                  style: regularTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          );
        }
      });
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
                text: 'Pesanan Saya',
                onPressed: () {
                  pushNewScreen(context,
                      screen: const OrderListScreen(), withNavBar: false);
                }),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/menunggu.png',
                text: 'Menunggu Pembayaran',
                onPressed: () {
                  pushNewScreen(context,
                      screen: PendingPaymentScreen(), withNavBar: false);
                }),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/editprofile.png',
                text: 'Edit Profil',
                onPressed: () {
                  pushNewScreen(context,
                      screen: const EditProfilePage(), withNavBar: false);
                }),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/gantisandi.png',
                text: 'Ganti Kata Sandi',
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
                imagePath: 'assets/images/editalamat.png',
                text: 'Edit Alamat',
                onPressed: () {
                  pushNewScreen(context,
                      screen: const ListAddressPage(), withNavBar: false);
                }),
            const SizedBox(
              height: 15,
            ),
            SettingsCard(
                imagePath: 'assets/images/tentang.png',
                text: 'Tentang Kami',
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
                imagePath: 'assets/images/logout.png',
                text: 'Log Out',
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  final prefs = SharedPreferences.getInstance();
                  prefs.then((value) => value.clear());

                  pushNewScreen(context,
                      screen: const BottomNavigationBarWidget(),
                      withNavBar: false);
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          'My Profile',
          style: boldTextStyle.copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            top(),
            const SizedBox(
              height: 15,
            ),
            body(),
          ],
        ),
      ),
    );
  }
}
