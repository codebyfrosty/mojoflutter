class OrderModel {
  String id;
  Buyyer buyyer;
  String status;
  Destination destination;
  Courier courier;
  int totalQuantity;
  int? totalProductPrice;
  int shippingCost;
  int totalCost;
  DateTime createdAt;
  DateTime? updatedAt;
  List<OrderItem> orderItems;

  OrderModel({
    required this.id,
    required this.buyyer,
    required this.status,
    required this.destination,
    required this.courier,
    required this.totalQuantity,
    required this.totalProductPrice,
    required this.shippingCost,
    required this.totalCost,
    required this.createdAt,
    this.updatedAt,
    required this.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        buyyer: Buyyer.fromJson(json["buyyer"]),
        status: json["status"],
        destination: Destination.fromJson(json["destination"]),
        courier: Courier.fromJson(json["courier"]),
        totalQuantity: json["total_quantity"],
        totalProductPrice: json["total_product_price"],
        shippingCost: json["shipping_cost"],
        totalCost: json["total_cost"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        orderItems: List<OrderItem>.from(
          json["order_items"].map((x) => OrderItem.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "buyyer": buyyer.toJson(),
        "status": status,
        "destination": destination.toJson(),
        "courier": courier.toJson(),
        "total_quantity": totalQuantity,
        "total_product_price": totalProductPrice,
        "shipping_cost": shippingCost,
        "total_cost": totalCost,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class Buyyer {
  String name;
  String email;
  String phone;

  Buyyer({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Buyyer.fromJson(Map<String, dynamic> json) => Buyyer(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
      };
}

class Courier {
  String companyName;
  String serviceType;

  Courier({
    required this.companyName,
    required this.serviceType,
  });

  factory Courier.fromJson(Map<String, dynamic> json) => Courier(
        companyName: json["company_name"],
        serviceType: json["service_type"],
      );

  Map<String, dynamic> toJson() => {
        "company_name": companyName,
        "service_type": serviceType,
      };
}

class Destination {
  String address;
  String province;
  String city;
  String district;
  String postalCode;

  Destination({
    required this.address,
    required this.province,
    required this.city,
    required this.district,
    required this.postalCode,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        address: json["address"],
        province: json["province"],
        city: json["city"],
        district: json["district"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "province": province,
        "city": city,
        "district": district,
        "postal_code": postalCode,
      };
}

class OrderItem {
  String sku;
  String name;
  String image;
  int price;
  int weightValue;
  String weightUnit;
  int quantity;
  int totalPrice;
  List<ItemStatusHistory> itemStatusHistory;

  OrderItem({
    required this.sku,
    required this.name,
    required this.image,
    required this.price,
    required this.weightValue,
    required this.weightUnit,
    required this.quantity,
    required this.totalPrice,
    required this.itemStatusHistory,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        sku: json["sku"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        weightValue: json["weight"]["value"],
        weightUnit: json["weight"]["unit"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        itemStatusHistory: List<ItemStatusHistory>.from(
          json["item_status_history"].map((x) => ItemStatusHistory.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "sku": sku,
        "name": name,
        "image": image,
        "price": price,
        "weight": {"value": weightValue, "unit": weightUnit},
        "quantity": quantity,
        "total_price": totalPrice,
        "item_status_history":
            List<dynamic>.from(itemStatusHistory.map((x) => x.toJson())),
      };
}

class ItemStatusHistory {
  String status;
  String note;
  DateTime updatedAt;

  ItemStatusHistory({
    required this.status,
    required this.note,
    required this.updatedAt,
  });

  factory ItemStatusHistory.fromJson(Map<String, dynamic> json) =>
      ItemStatusHistory(
        status: json["status"],
        note: json["note"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "note": note,
        "updated_at": updatedAt.toIso8601String(),
      };
}