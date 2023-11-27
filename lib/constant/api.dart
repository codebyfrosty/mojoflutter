import 'package:intl/intl.dart';

const baseUrl = 'https://toko-mojopahit-production.up.railway.app/v1';

enum Status {
  loading,
  success,
  error,
  empty,
}

enum UserProfileState {
  Loading,
  Loaded,
  Error,
}

enum CartStatus { Loading, Error, Success, Empty }

enum WishStatus { loading, success, empty, error }

enum AddressStatus { loading, success, empty, error }

enum OrderStatus { loading, success, empty, error }

String formatPrice(double price) {
  final currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  return currencyFormat.format(price);
}
