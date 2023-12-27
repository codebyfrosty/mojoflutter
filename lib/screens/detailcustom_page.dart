import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar/model/cart_model.dart';
import 'package:flutter_ar/model/product_model.dart';
import 'package:flutter_ar/provider/auth_provider.dart';
import 'package:flutter_ar/provider/cart_provider.dart';
import 'package:flutter_ar/provider/product_provider.dart';
import 'package:flutter_ar/provider/wishlist_provider.dart';
import 'package:flutter_ar/screens/ar_page.dart';
import 'package:flutter_ar/screens/augmentedr_page.dart';
import 'package:flutter_ar/screens/cart_page.dart';
import 'package:flutter_ar/screens/detailsatu_pesanan.dart';
import 'package:flutter_ar/screens/login_page.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../constant/api.dart';

String formatPriceAsRupiah(int price) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return formatter.format(price);
}

class DetailCustomPage extends StatefulWidget {
  final int id;
  final Product product;
  const DetailCustomPage({
    super.key,
    required this.id,
    required this.product,
  });

  @override
  State<DetailCustomPage> createState() => _DetailCustomPageState();
}

class _DetailCustomPageState extends State<DetailCustomPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<DetailProductProvider>(context, listen: false)
            .fetchDetailProduct(widget.id));
  }

  final TextEditingController _selectedValueController =
      TextEditingController();
  final bool isCitySelected = true;

  @override
  void dispose() {
    super.dispose();
    _selectedValueController.dispose();
  }

  String formatPriceAsRupiah(int price) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    Widget content() {
      return Consumer<DetailProductProvider>(builder: (context, data, child) {
        if (data.status == Status.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.status == Status.error) {
          return Center(
            child: Text(data.error),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(children: [
                  Column(children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 2,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                      ),
                      items: data.detailProduct!.images.map((image) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                image.url,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ]),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                      left: 24,
                      right: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        SizedBox(
                          child: Row(
                            children: [
                              // IconButton(
                              //   onPressed: () {
                              //     pushNewScreen(context,
                              //         screen: LocalAndWebObjectsView(
                              //           product: data.detailProduct!,
                              //         ));
                              //   },
                              //   icon: const Icon(
                              //     Icons.camera_alt_rounded,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              IconButton(
                                onPressed: () {
                                  pushNewScreen(context,
                                      screen: ARPage(
                                        product: data.detailProduct!,
                                      ));
                                },
                                icon: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showFavModal(
                                      context, data.detailProduct!.variant);
                                },
                                icon: const Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 24.0, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.detailProduct!.name,
                              style: boldTextStyle.copyWith(fontSize: 20),
                            ),
                            if (data.detailProduct!.customizable == true &&
                                data.detailProduct!.variant.isNotEmpty)
                              Text(
                                formatPriceAsRupiah(
                                    data.detailProduct!.variant[0].price),
                                style: boldTextStyle.copyWith(fontSize: 20),
                              ),

                            // Variant option for non-customizable products
                            if (data.detailProduct!.customizable == false &&
                                data.detailProduct!.variant.isNotEmpty)
                              Text(
                                formatPriceAsRupiah(
                                    data.detailProduct!.variant[0].price),
                                style: boldTextStyle.copyWith(fontSize: 20),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.detailProduct!.description,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ukuran',
                          style: boldTextStyle.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Panjang (cm)   : ${data.detailProduct!.dimension.length}'),
                                const SizedBox(height: 4),
                                Text(
                                    'Tinggi  (cm)    : ${data.detailProduct!.dimension.height}')
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    'Lebar (cm)   : ${data.detailProduct!.dimension.width}')
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (data.detailProduct!.customizable == true)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              for (var selection
                                  in data.detailProduct!.selections)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selection.name,
                                      style:
                                          boldTextStyle.copyWith(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var option in selection.options)
                                          Text(
                                              '${option.value}'), // Replace ... with actual data
                                      ],
                                    ),
                                  ],
                                ),
                              const Spacer(),
                            ],
                          ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilledButton(
                              onPressed: () {
                                _showCurrentSelectionsModal(
                                    context, data.detailProduct!.variant);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: primaryColor,
                                minimumSize: const Size(270, 50),
                              ),
                              child: Text(
                                'Beli Langsung!',
                                style: boldTextStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  _showSelectionsModal(
                                      context, data.detailProduct!.variant);
                                },
                                icon: const Icon(
                                  Icons.shopping_cart_rounded,
                                  color: primaryColor,
                                  size: 32,
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [content()],
        ),
      ),
    );
  }

  Widget dropDown() {
    return SizedBox(
      width: 115,
      height: 30,
      child: TextFormField(
        controller: _selectedValueController,
        cursorColor: Colors.black,
        onTap: () => onTapCallback(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          contentPadding:
              const EdgeInsets.only(left: 8, bottom: 0, top: 0, right: 15),
          hintText: _selectedValueController.text.isEmpty
              ? 'Pilih Bahan'
              : _selectedValueController.text,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  void onTapCallback() {
    DropDownState(
      DropDown(
        isSearchVisible: false,
        isDismissible: true,
        bottomSheetTitle: const Text(
          'Pilih Bahan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        data: [
          SelectedListItem(name: 'Paris'),
          SelectedListItem(name: 'Madrid'),
          SelectedListItem(name: 'Dubai'),
          SelectedListItem(name: 'Rome'),
          SelectedListItem(name: 'Barcelona'),
          SelectedListItem(name: 'Cologne'),
          SelectedListItem(name: 'MonteCarlo'),
          SelectedListItem(name: 'Puebla'),
          SelectedListItem(name: 'Florence'),
        ],
        selectedItems: (List<dynamic> selectedList) {
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              list.add(item.name);
            }
          }
          _selectedValueController.text =
              list.toString().replaceAll('[', '').replaceAll(']', '');
          showSnackBar(list.toString().replaceAll('[', '').replaceAll(']', ''));
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryColor,
        duration: _selectedValueController.text.isEmpty
            ? const Duration(seconds: 1)
            : const Duration(seconds: 3),
      ),
    );
  }
}

Future<void> _showSelectionsModal(
  BuildContext context,
  List<Variant> variants,
) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Consumer<DetailProductProvider>(
        builder: (context, detail, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      'Pilih Variant',
                      style: boldTextStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (var variant in variants)
                          ChoiceChip(
                            selectedColor: primaryColor,
                            labelStyle: regularTextStyle.copyWith(
                              color: detail.selectedSku == variant.sku
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            label: Text(
                                '${variant.variantName.replaceAll('_', ' ')} - ${formatPriceAsRupiah(variant.price)}'),
                            selected: detail.selectedSku == variant.sku,
                            onSelected: (selected) {
                              detail.setSelectedSku(variant.sku);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Jumlah',
                      style: boldTextStyle.copyWith(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (detail.quantity > 1) {
                              detail.decreaseQuantity();
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline_rounded),
                        ),
                        Text('${detail.quantity}'),
                        IconButton(
                          onPressed: () {
                            detail.increaseQuantity();
                          },
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Quantity buttons
                const SizedBox(height: 15),

                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: FilledButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryColor,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            // Handle confirmation of variant and quantity
                            // debugPrint('Selected SKU: ${detail.selectedSku}');
                            // debugPrint('Quantity: ${detail.quantity}');
                            if (!authProvider.loggedIn) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Silahkan login terlebih dahulu'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            } else {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(
                                detail.selectedSku!,
                                detail.quantity,
                              );
                              pushNewScreen(
                                context,
                                screen: const CartPage(),
                                withNavBar: true,
                              );
                            }
                          },
                          child: const Text('Tambah ke cart'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> _showCurrentSelectionsModal(
  BuildContext context,
  List<Variant> variants,
) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Consumer<DetailProductProvider>(
        builder: (context, detail, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      'Pilih Variant',
                      style: boldTextStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (var variant in variants)
                          ChoiceChip(
                            selectedColor: primaryColor,
                            labelStyle: regularTextStyle.copyWith(
                              color: detail.selectedSku == variant.sku
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            label: Text(
                                '${variant.variantName.replaceAll('_', ' ')} - ${formatPriceAsRupiah(variant.price)}'),
                            selected: detail.selectedSku == variant.sku,
                            onSelected: (selected) {
                              detail.setSelectedSku(variant.sku);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Jumlah',
                      style: boldTextStyle.copyWith(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (detail.quantity > 1) {
                              detail.decreaseQuantity();
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline_rounded),
                        ),
                        Text('${detail.quantity}'),
                        IconButton(
                          onPressed: () {
                            detail.increaseQuantity();
                          },
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Quantity buttons
                const SizedBox(height: 15),

                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: FilledButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primaryColor,
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15)),
                          onPressed: () {
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);

                            if (!authProvider.loggedIn) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Silahkan login terlebih dahulu'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            } else {
                              final itemDetails = CartItem(
                                name: detail.detailProduct!.name,
                                price: detail.detailProduct!.variant[0].price
                                    .toDouble(),
                                quantity: detail.quantity,
                                sku: detail.selectedSku!,
                                imageUrl: detail.detailProduct!.images[0].url,
                                total: detail.detailProduct!.variant[0].price *
                                    detail.quantity.toDouble(),
                              );

                              pushNewScreen(context,
                                  screen: DetailSatuPesanan(
                                    itemDetails: itemDetails,
                                  ),
                                  withNavBar: true);
                            }
                          },
                          child: const Text('Buat Pesanan'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> _showFavModal(
  BuildContext context,
  List<Variant> variants,
) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Consumer<DetailProductProvider>(
        builder: (context, detail, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      'Pilih Variant untuk ditambahkan ke wishlist',
                      style: boldTextStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (var variant in variants)
                          ChoiceChip(
                            selectedColor: primaryColor,
                            labelStyle: regularTextStyle.copyWith(
                              color: detail.selectedSku == variant.sku
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            label: Text(
                                '${variant.variantName.replaceAll('_', ' ')} - ${formatPriceAsRupiah(variant.price)}'),
                            selected: detail.selectedSku == variant.sku,
                            onSelected: (selected) {
                              detail.setSelectedSku(variant.sku);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),

                // Quantity buttons
                const SizedBox(height: 15),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: ElevatedButton(
                          style: FilledButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryColor,
                            fixedSize: const Size(240, 50),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            Provider.of<WishProvider>(context, listen: false)
                                .addToWishlist(
                              detail.selectedSku!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Berhasil di tambahkan ke wishlist'),
                                backgroundColor: primaryColor,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Tambahkan'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
