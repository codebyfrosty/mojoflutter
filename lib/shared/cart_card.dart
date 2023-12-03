// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_ar/model/cart_model.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:intl/intl.dart';

class CartCard extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback onDelete;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final Function(int) onPriceChange;
  // final Function(bool) onCheckboxClicked;
  final Function(bool) onSelectionChange;

  bool? isAnyItemSelected;
  CartCard({
    super.key,
    required this.cartItem,
    required this.onDelete,
    required this.onIncrease,
    required this.onDecrease,
    required this.onPriceChange,
    required this.isAnyItemSelected,
    // required this.onCheckboxClicked,
    required this.onSelectionChange,
  });

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    final formattedPrice = currencyFormat.format(widget.cartItem.price);

    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width - (2 * 24),
      margin: const EdgeInsets.only(top: 10, left: 24, right: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Checkbox(
            activeColor: primaryColor,
            value: widget.cartItem.isSelected,
            onChanged: (value) {
              setState(() {
                widget.onSelectionChange(value!);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.cartItem.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  widget.cartItem.name,
                  style: boldTextStyle.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.cartItem.sku,
                style: regularTextStyle,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                formattedPrice,
                style: boldTextStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      widget.onDecrease();
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    widget.cartItem.quantity.toString(),
                    style: boldTextStyle.copyWith(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onIncrease();
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onDelete();
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
          const Spacer(),
        ],
      ),
    );
  }
}
