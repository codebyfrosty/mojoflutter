import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  ProductDetail? _productDetail;
  String _error = '';
  Status _status = Status.loading;

  List<Product> get products => _products;
  ProductDetail? get productDetail => _productDetail;
  String get error => _error;
  Status get status => _status;

  Future<List<Product>> fetchProducts() async {
    try {
      _status = Status.loading;
      notifyListeners();

      var response = await http.get(
        Uri.parse('$baseUrl/products'),
      );

      var data = jsonDecode(response.body)['data'];
      debugPrint('data: $data');

      List<Product> products = [];
      for (var productData in data) {
        products.add(Product.fromJson(productData));
      }

      _products = products;
      _error = '';
      _status = Status.success;
      notifyListeners();

      return products;
    } catch (error) {
      debugPrint('error: $error');
      _error = 'Error fetching products: $error';
      _status = Status.error;
      notifyListeners();

      throw Exception('$error');
    }
  }
}

// class DetailProductProvider extends ChangeNotifier {
//   ProductDetailData? _detailProduct;
//   String _error = '';
//   Status _status = Status.loading;

//   ProductDetailData? get detailProduct => _detailProduct;
//   String get error => _error;
//   Status get status => _status;

//   Future<void> fetchDetailProduct(int productId) async {
//     try {
//       _status = Status.loading;
//       notifyListeners();

//       var response = await http.get(
//         Uri.parse('$baseUrl/products/$productId'),
//       );

//       if (response.statusCode == 200) {
//         var responseData = json.decode(response.body)['data'];
//         // debugPrint('[data detail product]: $responseData');

//         _detailProduct = ProductDetailData.fromJson(responseData);

//         if (_detailProduct!.customizable == false) {
//           // If the product is not customizable, set selections to an empty list
//           _detailProduct!.selections = [];
//         }

//         _error = '';
//         _status = Status.success;
//       } else {
//         _detailProduct = null;
//         _error = 'Failed to fetch detail product: ${response.statusCode}';
//         _status = Status.error;
//       }

//       notifyListeners();
//     } catch (error) {
//       // _detailProduct = null;
//       _error = 'An error occurred while fetching detail product: $error';
//       debugPrint('[error detail product]: $error');
//       _status = Status.error;
//       notifyListeners();
//     }
//   }
// }
class DetailProductProvider extends ChangeNotifier {
  ProductDetailData? _detailProduct;
  String _error = '';
  Status _status = Status.loading;

  String? _selectedSku; // New field for selected SKU
  int _quantity = 1; // New field for quantity
  int _price = 0; // New field for price

  ProductDetailData? get detailProduct => _detailProduct;
  String get error => _error;
  Status get status => _status;
  String? get selectedSku => _selectedSku; // Getter for selected SKU
  int get quantity => _quantity; // Getter for quantity
  int get price => _price;

  // Method to set the selected SKU
  void setSelectedSku(String sku) {
    _selectedSku = sku;
    notifyListeners();
  }

  // Method to set the price
  void setPrice(int price) {
    _price = price;
    notifyListeners();
  }

  // Method to increase the quantity
  void increaseQuantity() {
    _quantity++;
    notifyListeners();
  }

  // Method to decrease the quantity
  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  Future<void> fetchDetailProduct(int productId) async {
    try {
      _status = Status.loading;
      notifyListeners();

      var response = await http.get(
        Uri.parse('$baseUrl/products/$productId'),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body)['data'];
        _detailProduct = ProductDetailData.fromJson(responseData);

        if (_detailProduct!.customizable == false) {
          _detailProduct!.selections = []; // Remove the selections
        }

        _error = '';
        _status = Status.success;
      } else {
        _detailProduct = null;
        _error = 'Failed to fetch detail product: ${response.statusCode}';
        _status = Status.error;
      }

      notifyListeners();
    } catch (error) {
      _error = 'An error occurred while fetching detail product: $error';
      debugPrint('[error detail product]: $error');
      _status = Status.error;
      notifyListeners();
    }
  }
}

class SelectedItemProvider extends ChangeNotifier {
  int _selectedItemId = -1;

  int get selectedItemId => _selectedItemId;

  void setSelectedItemId(int itemId) {
    _selectedItemId = itemId;
    notifyListeners();
  }
}

class AllCategoryProvider extends ChangeNotifier {
  List<Product> _products = [];
  String _error = '';
  Status _status = Status.loading;

  List<Product> get products => _products;
  String get error => _error;
  Status get status => _status;

  Future<List<Product>> fetchKursi() async {
    try {
      _status = Status.loading;
      notifyListeners();

      var response = await http.get(
        Uri.parse('$baseUrl/products'),
      );

      var data = jsonDecode(response.body)['data'];
      // debugPrint('[data kursi only]: $data');

      List<Product> products = [];
      for (var productData in data) {
        products.add(Product.fromJson(productData));
      }

      _products = products;
      _error = '';
      _status = Status.success;
      notifyListeners();

      return products;
    } catch (error) {
      // debugPrint('[error kursi only]: $error');
      _error = 'Error fetching: $error';
      _status = Status.error;
      notifyListeners();

      throw Exception('$error');
    }
  }
}

class KursiCategoryProvider extends ChangeNotifier {
  List<Product> _products = [];
  String _error = '';
  Status _status = Status.loading;

  List<Product> get products => _products;
  String get error => _error;
  Status get status => _status;

  Future<List<Product>> fetchKursi() async {
    try {
      _status = Status.loading;
      notifyListeners();

      var response = await http.get(
        Uri.parse('$baseUrl/products?category=kursi'),
      );

      var data = jsonDecode(response.body)['data'];
      // debugPrint('[data kursi only]: $data');

      List<Product> products = [];
      for (var productData in data) {
        products.add(Product.fromJson(productData));
      }

      _products = products;
      _error = '';
      _status = Status.success;
      notifyListeners();

      return products;
    } catch (error) {
      // debugPrint('[error kursi only]: $error');
      _error = 'Error fetching kursi: $error';
      _status = Status.error;
      notifyListeners();

      throw Exception('$error');
    }
  }
}

class SofaCategoryProvider extends ChangeNotifier {
  List<Product> _products = [];
  String _error = '';
  Status _status = Status.loading;

  List<Product> get products => _products;
  String get error => _error;
  Status get status => _status;

  Future<List<Product>> fetchSofa() async {
    try {
      _status = Status.loading;
      notifyListeners();

      var response = await http.get(
        Uri.parse('$baseUrl/products?category=sofa'),
      );

      var responseData = jsonDecode(response.body);
      var data = responseData['data'];

      if (data.isEmpty) {
        _products = [];
        _error = '';
        _status = Status.empty;
      } else {
        List<Product> products = [];
        for (var productData in data) {
          products.add(Product.fromJson(productData));
        }
        _products = products;
        _error = '';
        _status = Status.success;
      }

      notifyListeners();

      return _products;
    } catch (error) {
      debugPrint('[error sofa only]: $error');
      _products = [];
      _error = 'Error fetching sofa: $error';
      _status = Status.error;
      notifyListeners();

      throw Exception('$error');
    }
  }
}

class MejaCategoryProvider extends ChangeNotifier {
  List<Product> _products = [];
  String _error = '';
  Status _status = Status.loading;

  List<Product> get products => _products;
  String get error => _error;
  Status get status => _status;

  Future<List<Product>> fetchMeja() async {
    try {
      _status = Status.loading;
      notifyListeners();

      var response = await http.get(
        Uri.parse('$baseUrl/products?category=meja'),
      );

      var responseData = jsonDecode(response.body);
      var data = responseData['data'];

      if (data.isEmpty) {
        _products = [];
        _error = '';
        _status = Status.empty;
      } else {
        List<Product> products = [];
        for (var productData in data) {
          products.add(Product.fromJson(productData));
        }
        _products = products;
        _error = '';
        _status = Status.success;
      }

      notifyListeners();

      return _products;
    } catch (error) {
      debugPrint('[error meja only]: $error');
      _products = [];
      _error = 'Error fetching meja: $error';
      _status = Status.error;
      notifyListeners();

      throw Exception('$error');
    }
  }
}

class LemariCategoryProvider extends ChangeNotifier {
  List<Product> _products = [];
  String _error = '';
  Status _status = Status.loading;

  List<Product> get products => _products;
  String get error => _error;
  Status get status => _status;

  Future<List<Product>> fetchLemari() async {
    try {
      _status = Status.loading;
      notifyListeners();

      var response = await http.get(
        Uri.parse('$baseUrl/products?category=lemari'),
      );

      var responseData = jsonDecode(response.body);
      var data = responseData['data'];

      if (data.isEmpty) {
        _products = [];
        _error = '';
        _status = Status.empty;
      } else {
        List<Product> products = [];
        for (var productData in data) {
          products.add(Product.fromJson(productData));
        }
        _products = products;
        _error = '';
        _status = Status.success;
      }

      notifyListeners();

      return _products;
    } catch (error) {
      debugPrint('[error lemari only]: $error');
      _products = [];
      _error = 'Error fetching lemari: $error';
      _status = Status.error;
      notifyListeners();

      throw Exception('$error');
    }
  }
}
