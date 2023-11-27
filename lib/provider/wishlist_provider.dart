import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/model/wish_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WishProvider extends ChangeNotifier {
  List<WishModel> _wishItems = [];
  WishStatus _wishStatus = WishStatus.loading;

  List<WishModel> get wishItems => _wishItems;
  WishStatus get wishStatus => _wishStatus;

  Future<List<WishModel>> fetchWishData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    _wishStatus = WishStatus.loading;
    notifyListeners();

    final url = Uri.parse('$baseUrl/wishlist');
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
          _wishItems =
              responseData.map((item) => WishModel.fromJson(item)).toList();
          _wishStatus = WishStatus.success;
          notifyListeners();
          return _wishItems;
        } else {
          _wishStatus = WishStatus.empty;
          notifyListeners();
          return [];
        }
      } else {
        _wishStatus = WishStatus.error;
        _wishItems = [];
        debugPrint('error: ${response.body}');
        notifyListeners();
        throw Exception('Failed to fetch cart data');
      }
    } catch (e) {
      _wishStatus = WishStatus.error;
      _wishItems = [];
      debugPrint('error: $e');

      notifyListeners();
      throw Exception('Failed to fetch fav data');
    }
  }

  Future<void> addToWishlist(String sku) async {
    _wishStatus = WishStatus.loading;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final url = Uri.parse('$baseUrl/wishlist');
    final requestData = {
      "sku": sku,
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
        var responseData = json.decode(response.body)['data'];
        debugPrint('responseData: $responseData');

        await fetchWishData();
      } else {
        debugPrint('error: ${response.body}');
        _wishStatus = WishStatus.error;
      }
    } catch (error) {
      debugPrint('error: $error');
      _wishStatus = WishStatus.error;
    }

    notifyListeners();
  }

  Future<void> deleteCartItem(String sku) async {
    _wishStatus = WishStatus.loading;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final url = Uri.parse('$baseUrl/wishlist/$sku');

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
        await fetchWishData();
      } else {
        debugPrint('error: ${response.body}');
        _wishStatus = WishStatus.error;
      }
    } catch (error) {
      debugPrint('error: $error');

      _wishStatus = WishStatus.error;
    }

    notifyListeners();
  }
}
