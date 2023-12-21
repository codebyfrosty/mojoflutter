class PaymentDetailModel {
  final String id;
  final String orderId;
  final String status;
  final String type;
  final String bank;
  final String vaNumber;
  final List<Map<String, dynamic>> orderItems;
  final String courierCompany;
  final int shippingCost;
  final int grossAmount;
  final String expiryTime;
  final String createdAt;
  final String paymentMethod;

  PaymentDetailModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.type,
    required this.bank,
    required this.vaNumber,
    required this.orderItems,
    required this.courierCompany,
    required this.shippingCost,
    required this.grossAmount,
    required this.expiryTime,
    required this.createdAt,
    required this.paymentMethod,
  });

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailModel(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      bank: json['bank'] ?? '',
      vaNumber: json['va_number'] ?? '',
      orderItems: List<Map<String, dynamic>>.from(json['order_items'] ?? []),
      courierCompany: json['courier_company'] ?? '',
      shippingCost: json['shipping_cost'] ?? 0,
      grossAmount: json['gross_amount'] ?? 0,
      expiryTime: json['expiry_time'] ?? '',
      createdAt: json['created_at'] ?? '',
      paymentMethod:
          json['payment_method'] ?? '',
    );
  }
}
