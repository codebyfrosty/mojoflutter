import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/provider/address_provider.dart';
import 'package:flutter_ar/screens/address_page.dart';
import 'package:flutter_ar/shared/address_card.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ListAddressPage extends StatefulWidget {
  const ListAddressPage({super.key});

  @override
  State<ListAddressPage> createState() => _ListAddressPageState();
}

class _ListAddressPageState extends State<ListAddressPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AddressProvider>(context, listen: false).fetchAddresses(context));
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
          actions: [
            IconButton(
                onPressed: () {
                  pushNewScreen(context, screen: const AddressPage());
                },
                icon: const Icon(
                  Icons.add_home_rounded,
                  color: primaryColor,
                ))
          ],
        ),
        body: Consumer<AddressProvider>(
          builder: (context, data, child) {
            if (data.adressStatus == AddressStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.adressStatus == AddressStatus.empty) {
              return const Center(child: Text('Address is empty'));
            } else if (data.adressStatus == AddressStatus.error) {
              return const Center(child: Text('Failed to load address data'));
            } else {
              return ListView.builder(
                itemCount: data.addresses.length,
                itemBuilder: (context, index) {
                  return AddressCard(
                      address: data.addresses[index],
                      onDelete: () {
                        data.deleteAddressItem(data.addresses[index].id, context);
                      });
                },
              );
            }
          },
        ),
      ),
    );
  }
}
