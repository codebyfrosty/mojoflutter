class PaymentModel {
  String id;
  String orderId;
  String status;
  String type;
  String bank;
  String vaNumber;
  List<OrderItem>? orderItems;
  String courierCompany;
  int shippingCost;
  int grossAmount;
  DateTime expiryTime;
  DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.type,
    required this.bank,
    required this.vaNumber,
    this.orderItems,
    required this.courierCompany,
    required this.shippingCost,
    required this.grossAmount,
    required this.expiryTime,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json["id"],
        orderId: json["order_id"],
        status: json["status"],
        type: json["type"],
        bank: json["bank"],
        vaNumber: json["va_number"],
        orderItems: json["order_items"] != null
            ? List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x)))
            : null,
        courierCompany: json["courier_company"],
        shippingCost: json["shipping_cost"],
        grossAmount: json["gross_amount"],
        expiryTime: DateTime.parse(json["expiry_time"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "status": status,
        "type": type,
        "bank": bank,
        "va_number": vaNumber,
        "order_items": orderItems != null
            ? List<dynamic>.from(orderItems!.map((x) => x.toJson()))
            : null,
        "courier_company": courierCompany,
        "shipping_cost": shippingCost,
        "gross_amount": grossAmount,
        "expiry_time": expiryTime.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}

class OrderItem {
  String itemName;
  int quantity;

  OrderItem({
    required this.itemName,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'item_name': itemName,
        'quantity': quantity,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        itemName: json['item_name'],
        quantity: json['quantity'],
      );
}