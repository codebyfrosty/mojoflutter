import 'package:flutter/material.dart';

import '../shared/theme.dart';

class ForgotpassPage extends StatelessWidget {
  const ForgotpassPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget emailField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              // labelText: 'Email',
              labelStyle: regularTextStyle,
              hintText: 'Masukkan email',
              hintStyle: regularTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'Pengaturan Akun',
          style: boldTextStyle,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                'Lupa Kata Sandi',
                style: boldTextStyle.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 2,
              ),
              Text('Masukkan e-mail untuk reset password',
                  style: regularTextStyle.copyWith(fontSize: 16),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 40,
              ),
              emailField(),
              const SizedBox(
                height: 15,
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
                      height: 8,
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/main');
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: primaryColor),
                        fixedSize: const Size(340, 50),
                      ),
                      child: Text(
                        'Batal',
                        style: boldTextStyle.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
