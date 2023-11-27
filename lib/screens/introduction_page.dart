// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_ar/shared/theme.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/intro.png',
              height: 550,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text('NIKMATI WAKTUMU',
                      style: boldTextStyle.copyWith(
                          fontSize: 30, fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Jelajahi, Temukan, dan Rancang Ruang\nSempurna Anda dengan Pengalaman\nToko Furnitur kami!',
                      style: regularTextStyle.copyWith(fontSize: 16)),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/main');
                      },
                      child: Text(
                        'Ayo Mulai!',
                        style: boldTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        fixedSize: const Size(340, 50),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
