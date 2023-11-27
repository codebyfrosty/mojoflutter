import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar/shared/theme.dart';
import '../shared/customlist_card.dart';

class CustomListPage extends StatelessWidget {
  const CustomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget listCustom() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTabController(
            length: 5,
            child: Column(
              children: [
                ButtonsTabBar(
                  contentPadding: EdgeInsets.all(10),
                  backgroundColor: primaryColor,
                  unselectedBackgroundColor: Colors.white,
                  unselectedLabelStyle:
                      boldTextStyle.copyWith(fontSize: 16, color: Colors.grey),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: 'Kursi'),
                    Tab(text: 'Meja'),
                    Tab(text: 'Lemari'),
                    Tab(text: 'Sofa'),
                    Tab(text: 'Tempat Tidur'),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: const [
                CustomListCard(),
                SizedBox(height: 8),
                CustomListCard(),
                SizedBox(height: 8),
                CustomListCard(),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      // resizeToAvoidBottomInset: true,
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
          'Daftar Pesanan Custom',
          style: boldTextStyle.copyWith(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            listCustom(),
          ],
        ),
      ),
    );
  }
}
