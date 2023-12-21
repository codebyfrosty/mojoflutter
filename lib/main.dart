import 'package:flutter/material.dart';
import 'package:flutter_ar/provider/address_provider.dart';
import 'package:flutter_ar/provider/auth_provider.dart';
import 'package:flutter_ar/provider/cart_provider.dart';
import 'package:flutter_ar/provider/order_provider.dart';
import 'package:flutter_ar/provider/orderdetail_provider.dart';
import 'package:flutter_ar/provider/payment_provider.dart';
import 'package:flutter_ar/provider/product_provider.dart';
import 'package:flutter_ar/provider/rate_provider.dart';
import 'package:flutter_ar/provider/wishlist_provider.dart';
import 'package:flutter_ar/screens/bottom_navigation_bar.dart';
import 'package:flutter_ar/screens/introduction_page.dart';
import 'package:flutter_ar/screens/login_page.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:provider/provider.dart';

import 'provider/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => SelectedItemProvider()),
        ChangeNotifierProvider(create: (context) => DetailProductProvider()),
        ChangeNotifierProvider(create: (context) => KursiCategoryProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ChangeNotifierProvider(create: (context) => SofaCategoryProvider()),
        ChangeNotifierProvider(create: (context) => MejaCategoryProvider()),
        ChangeNotifierProvider(create: (context) => LemariCategoryProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (context) => OrderDetailProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => WishProvider()),
        ChangeNotifierProvider(create: (context) => AddressProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => SelectedAddressProvider()),
        ChangeNotifierProvider(create: (context) => RateProvider()),
        ChangeNotifierProvider(create: (context) => BankProvider()),
        ChangeNotifierProvider(create: (context) => ChangePassProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/introduction': (context) => const IntroductionPage(),
          '/main': (context) => BottomNavigationBarWidget(),
        },
        title: 'Flutter AR',
        theme: ThemeData(
          primaryColor: primaryColor,
          fontFamily: 'Poppins',
        ),
        home: const IntroductionPage(),
      ),
    );
  }
}
