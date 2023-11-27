class AddressModel {
  int id;
  bool isPrimary;
  String contactName;
  String contactPhone;
  String address;
  String areaId;
  String province;
  String city;
  String district;
  String postalCode;
  String note;

  AddressModel({
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

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"],
        isPrimary: json["is_primary"],
        contactName: json["contact_name"],
        contactPhone: json["contact_phone"],
        address: json["address"],
        areaId: json["area_id"],
        province: json["province"],
        city: json["city"],
        district: json["district"],
        postalCode: json["postal_code"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_primary": isPrimary,
        "contact_name": contactName,
        "contact_phone": contactPhone,
        "address": address,
        "area_id": areaId,
        "province": province,
        "city": city,
        "district": district,
        "postal_code": postalCode,
        "note": note,
      };
}

class Location {
  String areaId;
  String province;
  String city;
  String district;
  String postalCode;
  String name;

  Location({
    required this.areaId,
    required this.province,
    required this.city,
    required this.district,
    required this.postalCode,
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        areaId: json["area_id"],
        province: json["province"],
        city: json["city"],
        district: json["district"],
        postalCode: json["postal_code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "area_id": areaId,
        "province": province,
        "city": city,
        "district": district,
        "postal_code": postalCode,
        "name": name,
      };
}
