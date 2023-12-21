import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/model/payment_detail_model.dart';
import 'package:flutter_ar/model/payment_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider with ChangeNotifier {
  List<PaymentModel> _payments = [];
  bool _isLoading = false;
  String _error = '';
  late PaymentDetailModel paymentDetail;

  List<PaymentModel> get payments => _payments;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final response = await http.get(
        Uri.parse('$baseUrl/payments'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'] as List;
        _payments =
            responseData.map((item) => PaymentModel.fromJson(item)).toList();

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _error = 'Failed to fetch payments';
        notifyListeners();
      }
    } catch (error) {
      _isLoading = false;
      _error = 'An error occurred';
      notifyListeners();
    }
  }

  Future<PaymentDetailModel> fetchPaymentDetail(String paymentId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/payments/$paymentId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final paymentDetail = PaymentDetailModel.fromJson(responseData['data']);
        return paymentDetail;
      } else {
        throw Exception('Failed to fetch payment detail');
      }
    } catch (error) {
      throw Exception('Error fetching payment detail: $error');
    }
  }
}
