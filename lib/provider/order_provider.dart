import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  OrderStatus _orderStatus = OrderStatus.loading;

  List<OrderModel> get orders => _orders;
  OrderStatus get orderStatus => _orderStatus;

  Map<String, dynamic>? _createdOrderData;

  Map<String, dynamic>? get createdOrderData => _createdOrderData;

  void setCreatedOrderData(Map<String, dynamic> orderData) {
    _createdOrderData = orderData;
    notifyListeners();
  }

  Future<List<OrderModel>> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    _orderStatus = OrderStatus.loading;
    notifyListeners();
    final url = Uri.parse('$baseUrl/orders');

    try {
      _orderStatus = OrderStatus.loading;
      notifyListeners();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'] as List;
        debugPrint('data: $responseData');

        if (responseData.isNotEmpty) {
          _orders =
              responseData.map((item) => OrderModel.fromJson(item)).toList();

          _orderStatus = OrderStatus.success;
          notifyListeners();
          return _orders;
        } else {
          _orderStatus = OrderStatus.empty;
          notifyListeners();
          return [];
        }
      } else {
        _orderStatus = OrderStatus.error;
        _orders = [];
        debugPrint('error: ${response.body}');
        notifyListeners();
        throw Exception('Failed to fetch address data');
      }
    } catch (error) {
      _orderStatus = OrderStatus.error;
      _orders = [];
      debugPrint('error: $error');
      notifyListeners();
      throw Exception('Failed to fetch address data');
    }
  }

  Future<void> createOrder({
    required String courierCompany,
    required String courierType,
    required int addressId,
    required String bank,
    required List<Map<String, dynamic>> items,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url =
        Uri.parse('$baseUrl/checkout'); // Replace with your API endpoint

    final requestData = {
      "courier_company": courierCompany,
      "courier_type": courierType,
      "address_id": addressId,
      "bank": bank,
      "items": items,
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
        // Order created successfully
        // You can perform any necessary actions here
        _createdOrderData = json.decode(response.body)['data'];
        notifyListeners();
        debugPrint('response: ${response.body}');
      } else {
        debugPrint('error: ${response.body}');
        throw Exception('Failed to create order');
      }
    } catch (error) {
      debugPrint('error: $error');
      throw Exception('Error creating order: $error');
    }
  }

  // cancel order
  Future<void> cancelPayment({required String paymentId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/payments/$paymentId/cancel');

    final requestData = {
      "payment_id": paymentId,
    };

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
          body: json.encode(requestData));

      if (response.statusCode == 200) {
        debugPrint('response: ${response.body}');
      } else {
        debugPrint('error: ${response.body}');
        throw Exception('Failed to cancel payment');
      }
    } catch (e) {
      debugPrint('error: $e');
      throw Exception('Error cancel payment: $e');
    }
  }

  Future<void> check({required String paymentId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/payments/$paymentId/cancel');

    final requestData = {
      "payment_id": paymentId,
    };

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
          body: json.encode(requestData));

      if (response.statusCode == 200) {
        debugPrint('response: ${response.body}');
      } else {
        debugPrint('error: ${response.body}');
        throw Exception('Failed to cancel payment');
      }
    } catch (e) {
      debugPrint('error: $e');
      throw Exception('Error cancel payment: $e');
    }
  }
}
