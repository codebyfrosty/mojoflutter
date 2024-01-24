// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_ar/screens/register_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../shared/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final TextEditingController _emailController =
      TextEditingController(); // Controller for email field
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for password field

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
            controller: _emailController, // Set controller

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

    Widget kataSandi() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kata Sandi',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _passwordController, // Set controller
            obscureText: _isObscure,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                labelStyle: regularTextStyle,
                hintText: 'Masukkan kata sandi',
                hintStyle: regularTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    })),
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
        backgroundColor: Colors.transparent,
        title: Text(
          'Masuk',
          style: boldTextStyle,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Selamat datang kembali\ndi Mojopahit Furniture',
                  style: boldTextStyle.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40,
                ),
                emailField(),
                kataSandi(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          pushNewScreen(context, screen: const RegisterPage());
                        },
                        child: Text('Belum punya akun? Buat akun baru disini',
                            style: regularTextStyle)),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: FilledButton(
                    onPressed: () async {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);

                      try {
                        await authProvider.login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        if (authProvider.loggedIn) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login Sukses'),
                              backgroundColor: primaryColor,
                            ),
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/main',
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email atau kata sandi salah'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (error) {
                        String errorMessage = 'An error occurred';
                        if (error is String) {
                          errorMessage = error;
                        } else if (error is Exception) {
                          errorMessage = error.toString();
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login gagal'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      fixedSize: const Size(340, 50),
                    ),
                    child: Text(
                      'Masuk',
                      style: boldTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
