import 'package:flutter/material.dart';
import 'package:flutter_ar/provider/auth_provider.dart';
import 'package:flutter_ar/screens/cart_page.dart';
import 'package:flutter_ar/screens/favorite_page.dart';
import 'package:flutter_ar/screens/login_page.dart';
import 'package:flutter_ar/screens/notlogin_page.dart';
import 'package:flutter_ar/screens/profile_page.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  PersistentTabController? _controller;
  late bool _isLoggedIn = false;

  Future<void> _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false)
        .loggedIn; // Get the initial isLoggedIn value
// Get the initial isLoggedIn value
    _loadLoginState();
  }

  List<Widget> _buildScreens() {
    if (_isLoggedIn) {
      return [
        const HomePage(),
        const FavoritePage(),
        const CartPage(),
        const ProfilePage(),
      ];
    } else {
      return [
        const HomePage(),
        const NotLoginPage(),
      ];
    }
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    if (_isLoggedIn) {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: Colors.grey,
          title: "Home",
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite),
          title: "Favorite",
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          title: "Cart",
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: "Profile",
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    } else {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: Colors.grey,
          title: "Home",
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.login),
          title: "Login",
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: Colors.grey,
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
    );
  }
}
