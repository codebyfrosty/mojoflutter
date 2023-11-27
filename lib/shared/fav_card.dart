import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/model/wish_model.dart';
import 'package:flutter_ar/shared/theme.dart';

class FavCard extends StatelessWidget {
  final WishModel wishModel;
  final VoidCallback onDelete;

  const FavCard({
    super.key,
    required this.wishModel,
    required this.onDelete,
  });

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
              child: Image.asset(
                'assets/images/kursi1.png',
                width: 80,
                height: 80,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            ],
          ),
          const Spacer(),
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
