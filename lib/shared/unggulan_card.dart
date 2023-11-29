// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/model/product_model.dart';
import 'package:flutter_ar/provider/product_provider.dart';
import 'package:flutter_ar/screens/detailcustom_page.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class UnggulanCard extends StatelessWidget {
  final Product product;

  const UnggulanCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: DetailCustomPage(
            product: product,
            id: product.id,
          ),
          withNavBar: false,
        );
        context.read<SelectedItemProvider>().setSelectedItemId(product.id);
      },
      child: Container(
        height: 100,
        width: 250,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product.images[0].url,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: boldTextStyle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    product.category,
                    style: regularTextStyle,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    formatPrice(product.minPrice.toDouble()),
                    style: boldTextStyle,
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
