// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar/provider/user_provider.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/profile_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _tanggalLahirController.text =
            "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget nameField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Nama Lengkap',
              style: boldTextStyle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: TextFormField(
              controller: _nameController,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Nomor Hp',
              style: boldTextStyle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: TextFormField(
              controller: _noHpController,
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
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    }

    Widget tanggalLahirField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Tanggal Lahir',
              style: boldTextStyle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: TextFormField(
              controller: _tanggalLahirController,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  padding: const EdgeInsets.only(left: 20),
                  onPressed: () {
                    _selectDate(context); // Call _selectDate method here
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                ),
                contentPadding: const EdgeInsets.all(20),
                labelStyle: regularTextStyle,
                hintText: 'Masukkan Tanggal Lahir',
                hintStyle: regularTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      );
    }

    return Builder(builder: (context) {
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
            'Edit Profile',
            style: boldTextStyle,
          ),
        ),
        body: ListView(
          children: [
            GestureDetector(
              onTap: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  File imageFile = File(pickedFile.path);

                  try {
                    final imageUploadProvider =
                        Provider.of<ImageUploadProvider>(context,
                            listen: false);

                    // Set loading state to true before starting upload
                    imageUploadProvider.setLoadingState(true);

                    ImageUploadResponse? response =
                        await imageUploadProvider.uploadImage(imageFile);

                    // Reset loading state after upload is completed
                    imageUploadProvider.setLoadingState(false);

                    if (response != null) {
                      debugPrint(
                          'Image uploaded successfully: ${response.imageUrl}');

                      Provider.of<UserProfileProvider>(context, listen: false)
                          .updateProfilePicture(response.id);
                      Navigator.pop(context);
                    } else {
                      debugPrint('Image upload failed.');
                      // Handle upload failure, show an error message, etc.
                    }
                  } catch (error) {
                    debugPrint('Error uploading image: $error');
                    // Handle error, show an error message, etc.
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profil1.png'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Unggah foto disini',
                    style: boldTextStyle.copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            nameField(),
            dropDown(),
            noHp(),
            tanggalLahirField(),
            const SizedBox(height: 30),
            Center(
              child: FilledButton(
                onPressed: () async {
                  final userProfileProvider =
                      Provider.of<UserProfileProvider>(context, listen: false);

                  await userProfileProvider.updateUserProfile(
                    name: _nameController.text,
                    gender: _genderController.text,
                    phone: _noHpController.text,
                    date: _tanggalLahirController.text,
                  );

                  Navigator.pop(context);
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
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget dropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Pilih Jenis Kelamin',
            style: boldTextStyle,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: TextFormField(
            controller: _genderController,
            onTap: () => onTapCallback(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              hintText: _genderController.text.isEmpty
                  ? 'Pilih Jenis Kelamin'
                  : _genderController.text,
              hintStyle: regularTextStyle,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }

  void onTapCallback() {
    DropDownState(
      DropDown(
        isSearchVisible: false,
        isDismissible: true,
        bottomSheetTitle: const Text(
          'Jenis Kelamin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        data: [
          SelectedListItem(name: 'male'),
          SelectedListItem(name: 'female'),
        ],
        selectedItems: (List<dynamic> selectedList) {
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              list.add(item.name);
            }
          }
          _genderController.text =
              list.toString().replaceAll('[', '').replaceAll(']', '');
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }
}
