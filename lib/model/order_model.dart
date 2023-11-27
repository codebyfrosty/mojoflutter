class OrderModel {
  String id;
  Buyyer buyyer;
  String status;
  Destination destination;
  Courier courier;
  int totalQuantity;
  TotalWeight totalWeight;
  int? totalProductPrice;
  int shippingCost;
  int totalCost;
  DateTime createdAt;
  DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.buyyer,
    required this.status,
    required this.destination,
    required this.courier,
    required this.totalQuantity,
    required this.totalWeight,
    this.totalProductPrice,
    required this.shippingCost,
    required this.totalCost,
    required this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        buyyer: Buyyer.fromJson(json["buyyer"]),
        status: json["status"],
        destination: Destination.fromJson(json["destination"]),
        courier: Courier.fromJson(json["courier"]),
        totalQuantity: json["total_quantity"],
        totalWeight: TotalWeight.fromJson(json["total_weight"]),
        totalProductPrice: json["total_product_price"],
        shippingCost: json["shipping_cost"],
        totalCost: json["total_cost"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "buyyer": buyyer.toJson(),
        "status": status,
        "destination": destination.toJson(),
        "courier": courier.toJson(),
        "total_quantity": totalQuantity,
        "total_weight": totalWeight.toJson(),
        "total_product_price": totalProductPrice,
        "shipping_cost": shippingCost,
        "total_cost": totalCost,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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

class TotalWeight {
  int value;
  String unit;

  TotalWeight({
    required this.value,
    required this.unit,
  });

  factory TotalWeight.fromJson(Map<String, dynamic> json) => TotalWeight(
        value: json["value"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
      };
}
