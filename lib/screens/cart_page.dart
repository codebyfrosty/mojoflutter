// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/provider/address_provider.dart';
import 'package:flutter_ar/provider/auth_provider.dart';
import 'package:flutter_ar/provider/cart_provider.dart';
import 'package:flutter_ar/screens/detailpesanan_page.dart';
import 'package:flutter_ar/screens/login_page.dart';
import 'package:flutter_ar/shared/cart_card.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isAnyItemSelected = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<CartProvider>(context, listen: false).fetchCartData());
    Future.microtask(() =>
        Provider.of<AddressProvider>(context, listen: false).fetchAddresses());
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalPrice = cartProvider.calculateSelectedTotalPrice(
        cartProvider.cartItems.where((item) => item.isSelected).toList());
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    final formattedTotalPrice = currencyFormat.format(totalPrice);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Cart',
          style: boldTextStyle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, state, _) {
                if (state.cartState == CartStatus.Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.cartState == CartStatus.Empty) {
                  return const Center(child: Text('Cart is empty'));
                } else if (state.cartState == CartStatus.Error) {
                  return const Center(
                      child:
                          Text('Error fetching cart data, please try again'));
                } else {
                  return ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartCard(
                        cartItem: state.cartItems[index],
                        onDelete: () {
                          state.deleteCartItem(state.cartItems[index].sku);
                        },
                        onIncrease: () {
                          state.updateCartItemQuantity(
                              state.cartItems[index].sku,
                              state.cartItems[index].quantity + 1);
                        },
                        onDecrease: () {
                          state.updateCartItemQuantity(
                              state.cartItems[index].sku,
                              state.cartItems[index].quantity - 1);
                        },
                        onPriceChange: (_) {
                          state
                              .notifyListeners(); // Notify listeners to trigger a rebuild in the Consumer
                        },
                        isAnyItemSelected: isAnyItemSelected,
                        onSelectionChange: (value) {
                          state.updateCartItemSelection(index, value);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price:',
                      style: mediumTextStyle,
                    ),
                    Text(
                      cartProvider.cartItems
                              .where((item) => item.isSelected)
                              .isNotEmpty
                          ? formattedTotalPrice
                          : 'Rp 0',
                      style: boldTextStyle.copyWith(fontSize: 18),
                    ),
                  ],
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    style: FilledButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: primaryColor,
                      fixedSize: const Size(100, 50),
                    ),
                    onPressed: cartProvider.cartItems
                            .any((item) => item.isSelected)
                        ? () {
                            final selectedItems = cartProvider.cartItems
                                .where((item) => item.isSelected)
                                .toList();

                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);

                            if (authProvider.loggedIn) {
                              pushNewScreen(
                                context,
                                screen: DetailPesananPage(
                                    itemDetails: selectedItems),
                                withNavBar: false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Silahkan login terlebih dahulu'),
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }
                          }
                        : null,
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
