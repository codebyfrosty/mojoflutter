import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/model/rate_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum RateStatus { loading, success, error, empty }

class RateProvider with ChangeNotifier {
  List<dynamic> _pricing = [];
  RateStatus _rateStatus = RateStatus.loading;
  dynamic _selectedRate; // Variable to hold the selected rate

  List<dynamic> get pricing => _pricing;
  RateStatus get rateStatus => _rateStatus;
  dynamic get selectedRate => _selectedRate; // Getter for the selected rate

  // Method to set the selected rate
  void setSelectedRate(RateModel rate) {
    _selectedRate = rate;
    notifyListeners();
  }

  Future<List<RateModel>> fetchRates(
      int addressId, List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/rates'); // Replace with your API endpoint
    final requestData = {
      "address_id": addressId,
      "items": items,
    };

    _rateStatus = RateStatus.loading;
    notifyListeners();

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
        final responseData = json.decode(response.body)['data']['pricing'];
        // debugPrint('responseData: $responseData');
        if (responseData.isNotEmpty) {
          _pricing = responseData;
          _rateStatus = RateStatus.success;
          notifyListeners(); // Notify listeners after setting values
          return _pricing
              .map((rateData) => RateModel.fromJson(rateData))
              .toList();
        } else {
          _pricing = [];
          _rateStatus = RateStatus.empty;
          notifyListeners();
          return [];
        }
      } else {
        debugPrint('error: ${response.body}');
        _rateStatus = RateStatus.error;
        _pricing = [];
        notifyListeners();
        throw Exception('Error fetching rates: ${response.body}');
      }
    } catch (error) {
      debugPrint('error: $error');
      _rateStatus = RateStatus.error;
      _pricing = [];
      notifyListeners();
      throw Exception('Error fetching rates: $error');
    }
  }
}

class BankProvider with ChangeNotifier {
  List<String> _banks = ['permata', 'bca', 'bri', 'bni'];
  String? _selectedBank;

  List<String> get banks => _banks;
  String? get selectedBank => _selectedBank;

  void setSelectedBank(String bank) {
    _selectedBank = bank;
    notifyListeners();
  }
}
