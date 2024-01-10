import 'package:flutter/material.dart';
import 'package:flutter_ar/model/address_model.dart';
import 'package:flutter_ar/screens/address_page.dart';
import 'package:flutter_ar/screens/editaddress_page.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

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
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (address.isPrimary)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 116, 116, 116), // Ganti dengan warna primer yang diinginkan
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
                const SizedBox(
                  height: 5,
                ),
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
          Column(
            children: [
              IconButton(
                onPressed: () {
                  pushNewScreen(context,
                      screen: EditAddressPage(addressId: address.id));
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
              if (!address.isPrimary)
                IconButton(
                  onPressed: () {
                    onDelete();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
