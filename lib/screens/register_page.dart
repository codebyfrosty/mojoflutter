// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../shared/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final TextEditingController _emailController =
      TextEditingController(); // Controller for email field
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for email field
  final TextEditingController _nameController =
      TextEditingController(); // Controller for email field
  final TextEditingController _numberController =
      TextEditingController(); // Controller for email field
  final TextEditingController _confirmController =
      TextEditingController(); // Controller for email field

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    _confirmController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget nameField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Lengkap',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama lengkap tidak boleh kosong';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              // labelText: 'Nama Lengkap',
              labelStyle: regularTextStyle,
              hintText: 'Masukkan nama lengkap',
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
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password tidak boleh kosong';
              }
              return null;
            },
            obscureText: _isObscure,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                labelStyle: regularTextStyle,
                hintText: 'Masukkan Password',
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
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email tidak boleh kosong';
              }
              return null;
            },
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

    Widget noHp() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nomor Hp',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _numberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nomor Telepon tidak boleh kosong';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              // labelText: 'Nomor Hp',
              labelStyle: regularTextStyle,
              hintText: 'Masukkan Nomor Hp',
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

    Widget tempatLahirField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Konfirmasi Kata Sandi',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: _isObscure,
            controller: _confirmController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Konfirmasi Password tidak boleh kosong';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              // labelText: 'Tempat Lahir',
              labelStyle: regularTextStyle,
              hintText: 'Masukkan Konfirmasi Password',
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
        backgroundColor: Colors.transparent,
        title: Text(
          'Daftar',
          style: boldTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
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
                nameField(),
                emailField(),
                noHp(),
                kataSandi(),
                tempatLahirField(),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: FilledButton(
                    onPressed: () async {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);

                      if (_formKey.currentState!.validate()) {
                        try {
                          await authProvider.register(
                            name: 'reza rahardian',
                            email: 'reza@gmail.com',
                            password: '123456',
                            phone: '081299878879',
                            confirm_password: '123456',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Register Sukses'),
                              backgroundColor: primaryColor,
                            ),
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/main',
                            (route) => false,
                          );
                        } catch (error) {
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Register gagal, pastikan semua kolom diisi dengan benar'), // Display the error message
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      fixedSize: const Size(340, 50),
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
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
