import 'package:flutter/material.dart';
import 'package:flutter_ar/model/address_model.dart';
import 'package:flutter_ar/provider/address_provider.dart';
import 'package:flutter_ar/screens/address_page.dart';
import 'package:flutter_ar/screens/editaddress_page.dart';
import 'package:flutter_ar/screens/listaddress_page.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onDelete;

  const AddressCard({
    super.key,
    required this.address,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color checkIconColor = address.isPrimary ? Colors.green : Colors.grey;
    AddressProvider addressProvider =
        Provider.of<AddressProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (address.isPrimary)
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 116, 116, 116),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Utama',
                style: TextStyle(color: Colors.white),
              ),
            ),
          Text(
            '${address.contactName} - ${address.contactPhone}',
            style: boldTextStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.address,
                      style: regularTextStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${address.city}, ${address.province}',
                      style: regularTextStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      address.postalCode,
                      style: regularTextStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Rumah',
                      style: boldTextStyle.copyWith(color: primaryColor),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    final currentContext = context;
                    await addressProvider.setPrimaryAddress(address.id);
                    ScaffoldMessenger.of(currentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Alamat telah dijadikan alamat utama'),
                      ),
                    );
                    // Redirect ke halaman yang sama
                    Navigator.pushReplacement(
                      currentContext,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListAddressPage(),
                      ),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Gagal menjadikan alamat utama'),
                          backgroundColor: Colors.red),
                    );
                    print('Error: $error');
                  }
                },
                icon: Icon(Icons.check_circle),
                color: checkIconColor,
                iconSize: 30,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  pushNewScreen(
                    context,
                    screen: EditAddressPage(addressId: address.id),
                  );
                },
                child: const Text(
                  'Edit Alamat',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              if (!address.isPrimary)
                TextButton(
                  onPressed: () {
                    onDelete();
                  },
                  child: const Text(
                    'Hapus Alamat',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
