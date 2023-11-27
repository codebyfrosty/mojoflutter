import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../shared/theme.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key});

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscureBaru = true;
  String? _oldPassword;
  String? _newPassword;

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Call the change password function using Provider
      Provider.of<ChangePassProvider>(context, listen: false)
          .changePassword(_oldPassword!, _newPassword!)
          .then((response) {
        if (response == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: $response'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            obscureText: _isObscure,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kata sandi lama harus diisi';
              }
              return null;
            },
            onSaved: (value) {
              _oldPassword = value;
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                labelStyle: regularTextStyle,
                hintText: 'Masukkan kata sandi lama',
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

    Widget kataSandiBaru() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kata Sandi Baru',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kata sandi baru harus diisi';
              }
              if (value.length < 8) {
                return 'Kata sandi harus lebih dari 8 karakter';
              }
              if (!value.contains(RegExp(r'[A-Z]'))) {
                return 'Kata sandi harus mengandung huruf kapital';
              }
              if (!value.contains(RegExp(r'[0-9]'))) {
                return 'Kata sandi harus mengandung angka';
              }
              return null;
            },
            onSaved: (value) {
              _newPassword = value;
            },
            obscureText: _isObscureBaru,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                // labelText: 'Tanggal Lahir',
                labelStyle: regularTextStyle,
                hintText: 'Masukkan Kata sandi baru',
                hintStyle: regularTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                    icon: Icon(_isObscureBaru
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscureBaru = !_isObscureBaru;
                      });
                    })),
          ),
        ],
      );
    }

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
          'Ganti Kata Sandi',
          style: boldTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buat kata sandi baru',
                style: boldTextStyle.copyWith(fontSize: 24),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Kata sandi baru kamu harus berbeda dengan\nkata sandi yang kamu gunakan sekarang',
                style: regularTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                'Kata sandi harus lebih dari 8 Karakter',
                style: regularTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                'Kata sandi harus mengandung huruf kapital dan angka',
                style: regularTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              kataSandi(),
              kataSandiBaru(),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: FilledButton(
                  onPressed: () {
                    _submitForm(context);
                    // Navigator.pushNamed(context, '/main');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    fixedSize: const Size(340, 50),
                  ),
                  child: Text(
                    'Simpan',
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
    );
  }
}
