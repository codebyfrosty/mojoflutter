// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_ar/model/address_model.dart';
import 'package:flutter_ar/model/cart_model.dart';
import 'package:flutter_ar/model/rate_model.dart';
import 'package:flutter_ar/provider/address_provider.dart';
import 'package:flutter_ar/provider/order_provider.dart';
import 'package:flutter_ar/provider/rate_provider.dart';
import 'package:flutter_ar/screens/choose_address.dart';
import 'package:flutter_ar/screens/payment_page.dart';
import 'package:flutter_ar/shared/address_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../shared/theme.dart';

class DetailSatuPesanan extends StatefulWidget {
  final AddressModel? address;
  final CartItem itemDetails;
  final int? selectedAddressId;

  const DetailSatuPesanan(
      {super.key,
      this.address,
      required this.itemDetails,
      this.selectedAddressId});

  @override
  State<DetailSatuPesanan> createState() => _DetailSatuPesananState();
}

class _DetailSatuPesananState extends State<DetailSatuPesanan> {
  AddressModel? selectedAddress;

  String formatPrice(double price) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return currencyFormat.format(price);
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedAddressId != null) {
      selectedAddress = Provider.of<AddressProvider>(context, listen: false)
          .addresses
          .firstWhere((address) => address.id == widget.selectedAddressId);
    }
    Future.microtask(() => context.read<AddressProvider>().fetchAddresses());
  }

  @override
  Widget build(BuildContext context) {
    final selectedAddress =
        context.watch<SelectedAddressProvider>().selectedAddress;
    final selectedRate = context.watch<RateProvider>().selectedRate;
    final selectedBank = Provider.of<BankProvider>(context).selectedBank;
    final banks = Provider.of<BankProvider>(context).banks;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'Detail Pesanan',
          style: boldTextStyle.copyWith(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Alamat',
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              selectedAddress != null
                  ? GestureDetector(
                      onTap: () {
                        pushNewScreen(context,
                            screen: const ChooseAddressPage());
                      },
                      child: ChooseAddress(
                        address: selectedAddress,
                      ),
                    )
                  : ListTile(
                      title: const Text('Pilih Alamat'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        pushNewScreen(context,
                            screen: const ChooseAddressPage());
                      },
                    ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Barang',
                style: boldTextStyle,
              ),

              ListTile(
                title: Text(widget.itemDetails.name),
                subtitle: Text('${widget.itemDetails.quantity} pcs'),
                trailing: Text(
                  formatPrice(widget.itemDetails.price),
                  style: boldTextStyle,
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Text(
                'Pilih Pengiriman',
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              selectedRate != null
                  ? ListTile(
                      title: Text(
                          '${Provider.of<RateProvider>(context).selectedRate?.courierServiceName ?? 'Belum dipilih'}'),
                      subtitle: Text(
                          '${Provider.of<RateProvider>(context).selectedRate?.duration ?? ''}'),
                      // trailing: Text(
                      //     '${Provider.of<RateProvider>(context).selectedRate?.price ?? ''}'),
                      trailing: Text(
                        formatPrice(selectedRate.price.toDouble()),
                        style: boldTextStyle,
                      ),
                      onTap: () async {
                        final rates = await Provider.of<RateProvider>(context,
                                listen: false)
                            .fetchRates(
                          selectedAddress!.id,
                          [
                            {
                              'sku': widget.itemDetails.sku,
                              'quantity': widget.itemDetails.quantity
                            }
                          ],
                        );
                        _showRateModalBottomSheet(rates);
                      })
                  : ListTile(
                      title: const Text('Pilih Pengiriman'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        if (selectedAddress == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Silakan pilih alamat terlebih dahulu'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          final rates = await Provider.of<RateProvider>(context,
                                  listen: false)
                              .fetchRates(
                            selectedAddress.id,
                            // widget.itemDetails
                            //     .map((item) => {
                            //           'sku': item.sku,
                            //           'quantity': item.quantity
                            //         })
                            //     .toList(),
                            [
                              {
                                'sku': widget.itemDetails.sku,
                                'quantity': widget.itemDetails.quantity
                              }
                            ],
                          );
                          _showRateModalBottomSheet(rates);
                        }
                      },
                    ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Pilih Pembayaran',
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              selectedBank != null
                  ? ListTile(
                      title: Text(selectedBank),
                      onTap: () {
                        _showBankList(context, banks);
                      },
                    )
                  : ListTile(
                      title: const Text('Pilih Pembayaran'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showBankList(context, banks);
                      },
                    ),

              // Add a divider for visual separation
              const Divider(),
              const SizedBox(height: 20),
              Text(
                'Ringkasan Pesanan',
                style: boldTextStyle,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Harga'),
                  Text(
                    // 'Rp. ${widget.itemDetails.map((e) => e.price).reduce((a, b) => a + b)}',
                    // 'Rp. ${widget.itemDetails.price * widget.itemDetails.quantity}',
                    formatPrice(
                        widget.itemDetails.price * widget.itemDetails.quantity),
                    style: boldTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ongkos Kirim'),
                  Text(
                    // 'Rp. ${selectedRate?.price ?? 0}',
                    formatPrice(selectedRate?.price.toDouble() ?? 0),
                    style: boldTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pembayaran'),
                  Text(
                    // 'Rp. ${widget.itemDetails.price * widget.itemDetails.quantity + (selectedRate?.price ?? 0)}',
                    formatPrice(
                        widget.itemDetails.price * widget.itemDetails.quantity +
                            (selectedRate?.price ?? 0)),
                    style: boldTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await Provider.of<OrderProvider>(context, listen: false)
                        .createOrder(
                      addressId: selectedAddress!.id,
                      // items: widget.itemDetails
                      //     .map((item) => {
                      //           'sku': item.sku,
                      //           'quantity': item.quantity,
                      //         })
                      //     .toList(),
                      items: [
                        {
                          'sku': widget.itemDetails.sku,
                          'quantity': widget.itemDetails.quantity
                        }
                      ],
                      courierCompany: selectedRate.company,
                      courierType: selectedRate.type,
                      bank: selectedBank!,
                    );
                    pushNewScreen(context, screen: const PembayaranPage());
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: const Size(340, 50),
                  ),
                  child: const Text('Buat Pesanan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //

  void _showRateModalBottomSheet(List<RateModel> rates) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Text(
              'Pilih Pengiriman',
              style: boldTextStyle,
            ),
            const Divider(), // Add a divider for visual separation
            ListView.builder(
              shrinkWrap: true,
              itemCount: rates.length,
              itemBuilder: (context, index) {
                final rate = rates[index];
                return ListTile(
                  title: Text(rate.courierServiceName),
                  subtitle: Text('${rate.description} - ${rate.price}'),
                  onTap: () {
                    // Update the selected rate using RateProvider
                    Provider.of<RateProvider>(context, listen: false)
                        .setSelectedRate(rate);
                    Navigator.pop(context); // Close the bottom sheet
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showBankList(BuildContext context, List<String> banks) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: banks.map((bank) {
                final isSelected =
                    bank == Provider.of<BankProvider>(context).selectedBank;
                return GestureDetector(
                  onTap: () {
                    Provider.of<BankProvider>(context, listen: false)
                        .setSelectedBank(bank);
                    Navigator.pop(
                        context); // Close the bottom sheet after selection
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        bank,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
