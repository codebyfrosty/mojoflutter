class CartModel {
  final int id;
  final bool isPrimary;
  final String contactName;
  final String contactPhone;
  final String address;
  final String areaId;
  final String province;
  final String city;
  final String district;
  final String postalCode;
  final String note;
  bool isSelected = false;

  CartModel({
    required this.id,
    required this.isPrimary,
    required this.contactName,
    required this.contactPhone,
    required this.address,
    required this.areaId,
    required this.province,
    required this.city,
    required this.district,
    required this.postalCode,
    required this.note,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      isPrimary: json['is_primary'],
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      address: json['address'],
      areaId: json['area_id'],
      province: json['province'],
      city: json['city'],
      district: json['district'],
      postalCode: json['postal_code'],
      note: json['note'],
    );
  }
}

class CartItem {
  final String sku;
  final String name;
  final double price;
  final int quantity;
  final double total;
  final String imageUrl;
  bool isSelected = false;

  CartItem({
    required this.sku,
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
    required this.imageUrl,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    return CartItem(
      sku: json['sku'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      total: json['total'].toDouble(),
      imageUrl: image != null ? image['url'] : '',
    );
  }
}
