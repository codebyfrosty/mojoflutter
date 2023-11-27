class WishModel {
  String sku;
  String name;
  int price;
  bool available;
  ImageWish image;

  WishModel({
    required this.sku,
    required this.name,
    required this.price,
    required this.available,
    required this.image,
  });

  factory WishModel.fromJson(Map<String, dynamic> json) => WishModel(
        sku: json["sku"],
        name: json["name"],
        price: json["price"],
        available: json["available"],
        image: ImageWish.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "sku": sku,
        "name": name,
        "price": price,
        "available": available,
        "image": image.toJson(),
      };
}

class ImageWish {
  String id;
  String name;
  int order;
  String url;
  DateTime uploadedAt;

  ImageWish({
    required this.id,
    required this.name,
    required this.order,
    required this.url,
    required this.uploadedAt,
  });

  factory ImageWish.fromJson(Map<String, dynamic> json) => ImageWish(
        id: json["id"],
        name: json["name"],
        order: json["order"],
        url: json["url"],
        uploadedAt: DateTime.parse(json["uploaded_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "order": order,
        "url": url,
        "uploaded_at": uploadedAt.toIso8601String(),
      };
}
