import 'package:flutter/material.dart';
import 'package:flutter_ar/model/address_model.dart';
import 'package:flutter_ar/shared/theme.dart';

class ChooseAddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onTap;

  const ChooseAddressCard({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
          ],
        ),
      ),
    );
  }
}
