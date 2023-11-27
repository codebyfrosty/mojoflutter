import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  CartStatus _cartState = CartStatus.Loading;
  CartStatus get cartState => _cartState;
  bool isAnyItemSelected() {
    return cartItems.any((item) => item.isSelected);
  }

  double calculateSelectedTotalPrice(List<CartItem> selectedItems) {
    double total = 0;
    for (var cartItem in selectedItems) {
      total += cartItem.price * cartItem.quantity;
    }
    return total;
  }

  updateCartItemSelection(int index, bool isSelected) {
    _cartItems[index].isSelected = isSelected;
    notifyListeners();
  }

  Future<List<CartItem>> fetchCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    _cartState = CartStatus.Loading;
    notifyListeners();

    final url = Uri.parse('$baseUrl/carts');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'] as List;
        if (responseData.isNotEmpty) {
          _cartItems =
              responseData.map((item) => CartItem.fromJson(item)).toList();
          _cartState = CartStatus.Success;
          notifyListeners();
          return _cartItems;
        } else {
          _cartState = CartStatus.Empty;
          notifyListeners();
          return [];
        }
      } else {
        _cartState = CartStatus.Error;
        _cartItems = [];
        debugPrint('error: ${response.body}');
        notifyListeners();
        throw Exception('Failed to fetch cart data');
      }
    } catch (error) {
      _cartState = CartStatus.Error;
      _cartItems = [];
      debugPrint('error: $error');
      notifyListeners();
      throw Exception('Failed to fetch cart data');
    }
  }

  Future<void> addToCart(String sku, int quantity) async {
    _cartState = CartStatus.Loading;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final url = Uri.parse('$baseUrl/carts');
    final requestData = {
      "sku": sku,
      "quantity": quantity,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        // var responseData = json.decode(response.body)['data'];
        // debugPrint('responseData: $responseData');

        await fetchCartData();
      } else {
        debugPrint('error: ${response.body}');
        _cartState = CartStatus.Error;
      }
    } catch (error) {
      debugPrint('error: $error');
      _cartState = CartStatus.Error;
    }

    notifyListeners();
  }

  Future<void> deleteCartItem(String sku) async {
    _cartState = CartStatus.Loading;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final url = Uri.parse('$baseUrl/carts/$sku');

    try {
      final response = await http.delete(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body)['data'];
        debugPrint('responseData: $responseData');
        await fetchCartData();
      } else {
        debugPrint('error: ${response.body}');
        _cartState = CartStatus.Error;
      }
    } catch (error) {
      debugPrint('error: $error');

      _cartState = CartStatus.Error;
    }

    notifyListeners();
  }

  Future<void> updateCartItemQuantity(String sku, int newQuantity) async {
    _cartState = CartStatus.Loading;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final url = Uri.parse('$baseUrl/carts/$sku');
    final requestData = {
      "quantity": newQuantity,
    };

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        // Successful response, you can update the cart items or perform any other necessary actions
        // For example, you can call fetchCartData() to refresh the cart after updating the quantity.
        await fetchCartData();
      } else {
        debugPrint('error: ${response.body}');

        _cartState = CartStatus.Error;
      }
    } catch (error) {
      debugPrint('error: $error');

      _cartState = CartStatus.Error;
    }

    notifyListeners();
  }
}

class CartSelectionProvider extends ChangeNotifier {
  List<bool> _itemSelectedList = [];

  CartSelectionProvider(int itemCount) {
    _itemSelectedList = List.generate(itemCount, (_) => false);
  }

  bool isItemSelected(int index) {
    return _itemSelectedList[index];
  }

  void toggleItemSelection(int index) {
    _itemSelectedList[index] = !_itemSelectedList[index];
    notifyListeners();
  }

  bool isAnyItemSelected() {
    return _itemSelectedList.any((isSelected) => isSelected);
  }
}
