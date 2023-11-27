class RateModel {
  final String courierName;
  final String courierServiceName;
  final String courierServiceCode;
  final String description;
  final String duration;
  final String shipmentDurationRange;
  final String shipmentDurationUnit;
  final String serviceType;
  final String shippingType;
  final int price;
  final String company;
  final String type;

  RateModel({
    required this.courierName,
    required this.courierServiceName,
    required this.courierServiceCode,
    required this.description,
    required this.duration,
    required this.shipmentDurationRange,
    required this.shipmentDurationUnit,
    required this.serviceType,
    required this.shippingType,
    required this.price,
    required this.type,
    required this.company,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      courierName: json['courier_name'],
      courierServiceName: json['courier_service_name'],
      courierServiceCode: json['courier_service_code'],
      description: json['description'],
      duration: json['duration'],
      shipmentDurationRange: json['shipment_duration_range'],
      shipmentDurationUnit: json['shipment_duration_unit'],
      serviceType: json['service_type'],
      shippingType: json['shipping_type'],
      price: json['price'],
      company: json['company'],
      type: json['type'],
    );
  }
}
