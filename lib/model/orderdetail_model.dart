class OrderDetail {
  final String id;
  final String status;
  final DateTime createdAt;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final String destinationAddress;
  final String destinationProvince;
  final String destinationCity;
  final String destinationDistrict;
  final String destinationPostalCode;
  final String courierCompanyName;
  final String courierServiceType;
  final List<OrderItem> orderItems;
  final int totalQuantity;
  final int totalProductPrice;
  final int shippingCost;
  final int totalCost;
  final List<OrderHistory> orderHistory;

  OrderDetail({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    required this.destinationAddress,
    required this.destinationProvince,
    required this.destinationCity,
    required this.destinationDistrict,
    required this.destinationPostalCode,
    required this.courierCompanyName,
    required this.courierServiceType,
    required this.orderItems,
    required this.totalQuantity,
    required this.totalProductPrice,
    required this.shippingCost,
    required this.totalCost,
    required this.orderHistory,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items = json['order_items'] as List<dynamic>? ?? [];
    final List<OrderItem> orderItems = items.map((item) {
      if (item != null && item is Map<String, dynamic>) {
        return OrderItem.fromJson(item);
      }
      return OrderItem(sku: '', name: '', image: '', price: 0, quantity: 0);
    }).toList();

    final List<dynamic> history = json['order_history'] as List<dynamic>? ?? [];
    final List<OrderHistory> orderHistory = history.map((hist) {
      if (hist != null && hist is Map<String, dynamic>) {
        return OrderHistory.fromJson(hist);
      }
      return OrderHistory(status: '', note: '', updatedAt: DateTime.now());
    }).toList();

    return OrderDetail(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      buyerName: (json['buyer'] as Map<String, dynamic>?)?['name'] ?? '',
      buyerEmail: (json['buyer'] as Map<String, dynamic>?)?['email'] ?? '',
      buyerPhone: (json['buyer'] as Map<String, dynamic>?)?['phone'] ?? '',
      destinationAddress: (json['destination'] as Map<String, dynamic>?)?['address'] ?? '',
      destinationProvince: (json['destination'] as Map<String, dynamic>?)?['province'] ?? '',
      destinationCity: (json['destination'] as Map<String, dynamic>?)?['city'] ?? '',
      destinationDistrict: (json['destination'] as Map<String, dynamic>?)?['district'] ?? '',
      destinationPostalCode: (json['destination'] as Map<String, dynamic>?)?['postal_code'] ?? '',
      courierCompanyName: (json['courier'] as Map<String, dynamic>?)?['company_name'] ?? '',
      courierServiceType: (json['courier'] as Map<String, dynamic>?)?['service_type'] ?? '',
      orderItems: orderItems,
      totalQuantity: json['total_quantity'] ?? 0,
      totalProductPrice: json['total_product_price'] ?? 0,
      shippingCost: json['shipping_cost'] ?? 0,
      totalCost: json['total_cost'] ?? 0,
      orderHistory: orderHistory,
    );
  }
}

class OrderItem {
  final String sku;
  final String name;
  final String image;
  final int price;
  final int quantity;

  OrderItem({
    required this.sku,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 0,
    );
  }
}

class OrderHistory {
  final String status;
  final String note;
  final DateTime updatedAt;

  OrderHistory({
    required this.status,
    required this.note,
    required this.updatedAt,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      status: json['status'] ?? '',
      note: json['note'] ?? '',
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}