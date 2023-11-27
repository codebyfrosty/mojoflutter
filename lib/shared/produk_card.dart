import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../model/product_model.dart';
import '../provider/product_provider.dart';
import '../screens/detailcustom_page.dart';

class ProdukCard extends StatelessWidget {
  final Product product;
  const ProdukCard({super.key, required this.product});

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
        height: 150,
        width: 200,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/kursi1.png',
                  width: 180,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: boldTextStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                formatPrice(product.minPrice.toDouble()),
                style: boldTextStyle.copyWith(
                    fontSize: 16, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
