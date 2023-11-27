import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/model/address_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddressProvider with ChangeNotifier {
  int? _selectedAddressId;

  int? get selectedAddressId => _selectedAddressId;

  void setSelectedAddressId(int addressId) {
    _selectedAddressId = addressId;
    notifyListeners();
  }

  List<AddressModel> _addresses = [];
  AddressStatus _addressStatus = AddressStatus.loading;

  List<AddressModel> get addresses => _addresses;
  AddressStatus get adressStatus => _addressStatus;

  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;

  Future<List<AddressModel>> fetchAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    _addressStatus = AddressStatus.loading;
    notifyListeners();

    final url =
        Uri.parse('$baseUrl/users/addresses'); // Update the URL accordingly
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
        // debugPrint('data: $responseData');

        if (responseData.isNotEmpty) {
          _addresses =
              responseData.map((item) => AddressModel.fromJson(item)).toList();

          _addressStatus = AddressStatus.success;
          notifyListeners();
          return _addresses;
        } else {
          _addressStatus = AddressStatus.empty;
          notifyListeners();
          return [];
        }
      } else {
        _addressStatus = AddressStatus.error;
        _addresses = [];
        debugPrint('error: ${response.body}');
        notifyListeners();
        throw Exception('Failed to fetch address data');
      }
    } catch (error) {
      _addressStatus = AddressStatus.error;
      _addresses = [];
      debugPrint('error: $error');
      notifyListeners();
      throw Exception('Failed to fetch address data');
    }
  }

  Future<void> deleteAddressItem(int id) async {
    _addressStatus = AddressStatus.loading;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final url = Uri.parse('$baseUrl/users/addresses/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // var responseData = json.decode(response.body)['data'];
        // debugPrint('responseData: $responseData');
        await fetchAddresses();
      } else {
        debugPrint('error: ${response.body}');
        _addressStatus = AddressStatus.error;
      }
    } catch (error) {
      debugPrint('error: $error');

      _addressStatus = AddressStatus.error;
    }

    notifyListeners();
  }

  Future<void> createAddress(
      String contactName,
      String contactPhone,
      String fullAddress,
      String areaId,
      String province,
      String city,
      String district,
      String postalCode,
      String? note,
      bool isPrimary) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    try {
      // Set loading state before making the API call
      _isLoading = true;
      _error = '';

      final response = await http.post(
        Uri.parse('$baseUrl/users/addresses'), // Adjust the API endpoint
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: json.encode(
          {
            'contact_name': contactName,
            'contact_phone': contactPhone,
            'full_address': fullAddress,
            'area_id': areaId,
            'province': province,
            'city': city,
            'district': district,
            'postal_code': postalCode,
            'note': note,
            'is_primary': isPrimary,
          },
        ),
      );

      if (response.statusCode == 200) {
        // Address created successfully, you can handle success as needed
        debugPrint('response: ${response.body}');
        await fetchAddresses();
      } else {
        // Handle API error
        debugPrint('error: ${response.body}');
        _error = 'Error creating address'; // Set the error message
      }
    } catch (e) {
      // Handle exception
      _error = 'An error occurred'; // Set the error message
    } finally {
      // Set loading state back to false after API call completes
      _isLoading = false;
    }
  }
}

class SelectedAddressProvider with ChangeNotifier {
  AddressModel? _selectedAddress;

  AddressModel? get selectedAddress => _selectedAddress;

  void setSelectedAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }
}

class LocationProvider extends ChangeNotifier {
  List<Location> _searchResults = [];
  bool _isLoading = false;
  String _error = '';

  List<Location> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchLocations(String query) async {
    if (query.isEmpty) {
      // Return early if the query is empty
      _searchResults.clear();
      _error = '';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = '';

    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('$baseUrl/locations?search=$query'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body); // Parse response body
        _searchResults = (jsonData['data'] as List)
            .map((json) => Location.fromJson(json))
            .toList();
        debugPrint('data: $jsonData');
      } else {
        _error = 'Error fetching locations';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error fetching locations';
      _isLoading = false;
      notifyListeners();
    }
  }
}
