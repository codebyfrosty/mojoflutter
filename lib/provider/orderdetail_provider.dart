import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ar/model/orderdetail_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailProvider extends ChangeNotifier {
  OrderDetail? _orderDetail;

  OrderDetail? get orderDetail => _orderDetail;

  Future<OrderDetail?> fetchOrderDetail(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url = Uri.parse(
        'https://toko-mojopahit-production.up.railway.app/v1/orders/$orderId');

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _orderDetail = OrderDetail.fromJson(jsonData['data']);
        notifyListeners();
        return _orderDetail;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
