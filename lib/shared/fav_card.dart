import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/model/wish_model.dart';
import 'package:flutter_ar/provider/cart_provider.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:provider/provider.dart';

class FavCard extends StatelessWidget {
  final WishModel wishModel;
  final VoidCallback onDelete;

  const FavCard({
    Key? key,
    required this.wishModel,
    required this.onDelete,
  }) : super(key: key);

  Future<bool> addToCartCallback(BuildContext context) async {
    try {
      await Provider.of<CartProvider>(context, listen: false)
          .addToCart(wishModel.sku, 1);

      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width - (2 * 24),
      margin: const EdgeInsets.only(top: 10),
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
                wishModel.image.url,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: ClipRRect(
          //       borderRadius: BorderRadius.circular(15),
          //       child: Image.network(
          //         wishModel.image.url,
          //         width: 80,
          //         height: 80,
          //       )),
          // ),
          const SizedBox(width: 10),
          Container(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Text(
                    wishModel.name,
                    style: boldTextStyle.copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  wishModel.sku,
                  style: regularTextStyle,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  formatPrice(wishModel.price.toDouble()),
                  style: boldTextStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () async {
              bool success = await addToCartCallback(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Produk berhasil ditambahkan ke cart'
                        : 'Gagal menambahkan produk ke cart',
                  ),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
              size: 20,
            ),
            label: SizedBox.shrink(),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, backgroundColor: primaryColor),
          ),
          IconButton(
              onPressed: () {
                onDelete();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}
