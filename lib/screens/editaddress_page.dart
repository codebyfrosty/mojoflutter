// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_ar/model/address_model.dart';
import 'package:flutter_ar/provider/address_provider.dart';
import 'package:provider/provider.dart';

import '../shared/theme.dart';

class EditAddressPage extends StatefulWidget {
  final int addressId;

  const EditAddressPage({Key? key, required this.addressId}) : super(key: key);

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late AddressModel _addressData;
  double _showList = 0.0;

  @override
  void initState() {
    super.initState();
    _loadAddressData();
  }

  Future<void> _loadAddressData() async {
    try {
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      final _addressData =
          await addressProvider.getAddresses(widget.addressId, context);
      if (_addressData != null) {
        setState(() {
          _nameController.text = _addressData.contactName;
          _fullAddressController.text = _addressData.address;
          _numberController.text = _addressData.contactPhone;
          _addressController.text = _addressData.district;
          _noteController.text = _addressData.note;
          _isPrimary = _addressData.isPrimary;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load address data'),
        ),
      );
    }
  }

  bool _isPrimary = false;
  final TextEditingController _noteController =
      TextEditingController(); // Controller for email field
  final TextEditingController _fullAddressController =
      TextEditingController(); // Controller for email field
  final TextEditingController _nameController =
      TextEditingController(); // Controller for email field
  final TextEditingController _numberController =
      TextEditingController(); // Controller for email field
  final TextEditingController _addressController =
      TextEditingController(); // Controller for email field

  String selectedLocationName = '';
  String selectedAreaId = '';
  String selectedProvince = '';
  String selectedCity = '';
  String selectedDistrict = '';
  String selectedPostalCode = '';

  @override
  void dispose() {
    _noteController.dispose();
    _fullAddressController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    _addressController.dispose();
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

    Widget fullAddress() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alamat rumah',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _fullAddressController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              labelStyle: regularTextStyle,
              hintText: 'Masukkan alamat lengkap',
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

    Widget jadikanAlamatUtama() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jadikan Alamat Utama',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Switch.adaptive(
            activeColor: primaryColor,
            value: _isPrimary,
            onChanged: (newValue) {
              setState(() {
                _isPrimary = newValue;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    }

    Widget kecamatanInput() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kecamatan / Kota / Provinsi / Kode Pos',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onChanged: (value) {
              Provider.of<LocationProvider>(context, listen: false)
                  .fetchLocations(value);
              _showList = 200;
            },
            controller: _addressController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              labelStyle: regularTextStyle,
              hintText: 'Masukkan catatan tentang alamat anda',
              hintStyle: regularTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Consumer<LocationProvider>(
            builder: (context, locationProvider, _) {
              if (locationProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (locationProvider.error.isNotEmpty) {
                return Text(locationProvider.error);
              } else {
                if (_addressController.text.isNotEmpty) {
                  return SizedBox(
                    height: _showList,
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            locationProvider.searchResults.map((location) {
                          return ListTile(
                            title: Text(location.name),
                            onTap: () {
                              selectedLocationName = location.name;
                              selectedAreaId = location.areaId;
                              selectedProvince = location.province;
                              selectedCity = location.city;
                              selectedDistrict = location.district;
                              selectedPostalCode = location.postalCode;

                              // Set the _addressController with the selected location name
                              _addressController.text = selectedLocationName;

                              // Update the state to hide the list
                              setState(() {
                                _showList = 0;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    }

    Widget noTe() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catatan (opsional)',
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _noteController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              // labelText: 'Nomor Hp',
              labelStyle: regularTextStyle,
              hintText: 'Masukkan catatan tentang alamat anda',
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Edit Alamat',
          style: boldTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              nameField(),
              noHp(),
              fullAddress(),
              kecamatanInput(),
              jadikanAlamatUtama(),
              noTe(),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: FilledButton(
                  onPressed: () async {
                    final locProvider =
                        Provider.of<AddressProvider>(context, listen: false);

                    try {
                      await locProvider.updateAddress(
                          _nameController.text,
                          _numberController.text,
                          _fullAddressController.text,
                          selectedAreaId,
                          selectedProvince,
                          selectedCity,
                          selectedDistrict,
                          selectedPostalCode,
                          _noteController.text,
                          _isPrimary,
                          widget.addressId,
                          context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sukses memperbaharui alamat'),
                          backgroundColor: primaryColor,
                        ),
                      );
                      Navigator.pop(context);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
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
                    'Simpan',
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
    );
  }
}
