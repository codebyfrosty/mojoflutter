import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/provider/address_provider.dart';
import 'package:flutter_ar/screens/address_page.dart';

import 'package:flutter_ar/shared/choose_address_card.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ChooseAddressPage extends StatefulWidget {
  const ChooseAddressPage({super.key});

  @override
  State<ChooseAddressPage> createState() => _ChooseAddressPageState();
}

class _ChooseAddressPageState extends State<ChooseAddressPage> {
  int? selectedAddressId;
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AddressProvider>(context, listen: false).fetchAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            'Alamat Saya',
            style: boldTextStyle,
          ),
        ),
        body: Consumer<AddressProvider>(
          builder: (context, data, child) {
            if (data.adressStatus == AddressStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.adressStatus == AddressStatus.empty) {
              return Center(
                  child: TextButton(
                      onPressed: () {
                        pushNewScreen(context, screen: const AddressPage());
                      },
                      child: Text(
                        'Tambah Alamat',
                        style: mediumTextStyle.copyWith(color: primaryColor),
                      )));
            } else if (data.adressStatus == AddressStatus.error) {
              return const Center(child: Text('Failed to load address data'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: data.addresses.length,
                itemBuilder: (context, index) {
                  final address = data.addresses[index];
                  final isSelected = address.id ==
                      context
                          .watch<SelectedAddressProvider>()
                          .selectedAddress
                          ?.id;
                  return ChooseAddressCard(
                      address: data.addresses[index],
                      onTap: () {
                        if (isSelected) {
                          context
                              .read<SelectedAddressProvider>()
                              .setSelectedAddress(address);
                          Navigator.pop(context, address);
                        } else {
                          context
                              .read<SelectedAddressProvider>()
                              .setSelectedAddress(address);
                        }
                      },
                      isSelected: isSelected);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
