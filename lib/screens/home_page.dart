import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar/provider/product_provider.dart';
import 'package:flutter_ar/shared/produk_card.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:flutter_ar/shared/unggulan_card.dart';
import 'package:provider/provider.dart';

import '../constant/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
    );
    Future.microtask(() =>
        Provider.of<KursiCategoryProvider>(context, listen: false)
            .fetchKursi());
    Future.microtask(() =>
        Provider.of<SofaCategoryProvider>(context, listen: false).fetchSofa());
    Future.microtask(() =>
        Provider.of<MejaCategoryProvider>(context, listen: false).fetchMeja());
    Future.microtask(() =>
        Provider.of<LemariCategoryProvider>(context, listen: false)
            .fetchLemari());
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar() {
      return Container(
        width: 340,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            suffixIcon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchText = value; // Simpan nilai pencarian
            });
          },
        ),
      );
    }

    Widget produkUnggulan() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produk Unggulan',
            style: boldTextStyle.copyWith(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 100,
            child: Consumer<ProductProvider>(
              builder: (context, data, child) {
                if (data.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (data.status == Status.success) {
                  if (data.products.isEmpty) {
                    return const Center(
                      child: Text('No products available.'),
                    );
                  } else {
                    final filteredProducts = data.products.where((product) =>
                      product.name.toLowerCase().contains(searchText.toLowerCase())).toList();

                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: filteredProducts
                          .map((product) => UnggulanCard(product: product))
                          .toList(),
                    );
                  }
                } else if (data.status == Status.error) {
                  return Center(
                    child: Text(
                      'Error: ${data.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return Container(); // Handle empty status here if needed
                }
              },
            ),
          ),
        ],
      );
    }

    Widget kursiOnly() {
      return SizedBox(
        // height: MediaQuery.of(context).size.height,
        child: Consumer<KursiCategoryProvider>(
          builder: (context, data, child) {
            if (data.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.status == Status.success) {
              if (data.products.isEmpty) {
                return const Center(
                  child: Text('No products available.'),
                );
              } else {
                final filteredProducts = data.products.where((product) =>
                      product.name.toLowerCase().contains(searchText.toLowerCase())).toList();

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: filteredProducts
                      .map((product) => ProdukCard(product: product))
                      .toList(),
                );
              }
            } else if (data.status == Status.error) {
              return Center(
                child: Text(
                  'Error: ${data.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
              return Container(); // Handle empty status here if needed
            }
          },
        ),
      );
    }

    Widget sofaOnly() {
      return SizedBox(
        // height: MediaQuery.of(context).size.height,
        child: Consumer<SofaCategoryProvider>(
          builder: (context, data, child) {
            if (data.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.status == Status.success) {
              if (data.products.isEmpty) {
                return const Center(
                  child: Text('No products available.'),
                );
              } else {
                final filteredProducts = data.products.where((product) =>
                      product.name.toLowerCase().contains(searchText.toLowerCase())).toList();

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: filteredProducts
                      .map((product) => ProdukCard(product: product))
                      .toList(),
                );
              }
            } else if (data.status == Status.error) {
              return Center(
                child: Text(
                  'Error: ${data.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (data.status == Status.empty) {
              return const Center(
                child: Text('No products available.'),
              );
            } else {
              return Container(); // Handle empty status here if needed
            }
          },
        ),
      );
    }

    Widget mejaOnly() {
      return SizedBox(
        // height: MediaQuery.of(context).size.height,
        child: Consumer<MejaCategoryProvider>(
          builder: (context, data, child) {
            if (data.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.status == Status.success) {
              if (data.products.isEmpty) {
                return const Center(
                  child: Text('No products available.'),
                );
              } else {
                final filteredProducts = data.products.where((product) =>
                      product.name.toLowerCase().contains(searchText.toLowerCase())).toList();

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: filteredProducts
                      .map((product) => ProdukCard(product: product))
                      .toList(),
                );
              }
            } else if (data.status == Status.error) {
              return Center(
                child: Text(
                  'Error: ${data.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (data.status == Status.empty) {
              return const Center(
                child: Text('No products available.'),
              );
            } else {
              return Container(); // Handle empty status here if needed
            }
          },
        ),
      );
    }

    Widget lemariOnly() {
      return SizedBox(
        // height: MediaQuery.of(context).size.height,
        child: Consumer<LemariCategoryProvider>(
          builder: (context, data, child) {
            if (data.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.status == Status.success) {
              if (data.products.isEmpty) {
                return const Center(
                  child: Text('No products available.'),
                );
              } else {
                final filteredProducts = data.products.where((product) =>
                      product.name.toLowerCase().contains(searchText.toLowerCase())).toList();

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: filteredProducts
                      .map((product) => ProdukCard(product: product))
                      .toList(),
                );
              }
            } else if (data.status == Status.error) {
              return Center(
                child: Text(
                  'Error: ${data.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (data.status == Status.empty) {
              return const Center(
                child: Text('No products available.'),
              );
            } else {
              return Container(); // Handle empty status here if needed
            }
          },
        ),
      );
    }

    Widget produkUtama() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produk',
            style: boldTextStyle.copyWith(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          DefaultTabController(
            length: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ButtonsTabBar(
                  contentPadding: EdgeInsets.all(10),
                  backgroundColor: primaryColor,
                  unselectedBackgroundColor: Colors.transparent,
                  unselectedLabelStyle: mediumTextStyle.copyWith(fontSize: 16),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: 'Kursi'),
                    Tab(text: 'Sofa'),
                    Tab(text: 'Meja'),
                    Tab(text: 'Lemari'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      kursiOnly(),
                      sofaOnly(),
                      mejaOnly(),
                      lemariOnly(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            "Mojopahit Furniture",
            style: boldTextStyle.copyWith(fontSize: 24),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              searchBar(),
              const SizedBox(height: 30),
              produkUnggulan(),
              const SizedBox(height: 30),
              produkUtama(),
            ],
          ),
        ),
      ),
    );
  }
}
