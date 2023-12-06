class Product {
  int id;
  final String name;
  final String description;
  final String category;
  Dimension dimension;
  Weight weight;
  final bool available;
  final bool featured;
  final bool customizable;
  final int minPrice;
  List<ImageModel> images;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.dimension,
    required this.weight,
    required this.available,
    required this.featured,
    required this.customizable,
    required this.minPrice,
    required this.images,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      dimension: Dimension.fromJson(json["dimension"]),
      weight: Weight.fromJson(json["weight"]),
      available: json['available'],
      featured: json['featured'],
      customizable: json['customizable'],
      minPrice: json['min_price'],
      images: List<ImageModel>.from(
          json["images"].map((x) => ImageModel.fromJson(x))),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Dimension {
  int width;
  int length;
  int height;
  String unit;

  Dimension({
    required this.width,
    required this.length,
    required this.height,
    required this.unit,
  });

  factory Dimension.fromJson(Map<String, dynamic> json) => Dimension(
        width: json["width"],
        length: json["length"],
        height: json["height"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "length": length,
        "height": height,
        "unit": unit,
      };
}

class ImageModel {
  String id;
  String name;
  int order;
  String url;
  DateTime uploadedAt;

  ImageModel({
    required this.id,
    required this.name,
    required this.order,
    required this.url,
    required this.uploadedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
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

class Weight {
  int value;
  String unit;

  Weight({
    required this.value,
    required this.unit,
  });

  factory Weight.fromJson(Map<String, dynamic> json) => Weight(
        value: json["value"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
      };
}

class ProductDetail {
  int code;
  String status;
  ProductDetailData data;

  ProductDetail({
    required this.code,
    required this.status,
    required this.data,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        code: json["code"],
        status: json["status"],
        data: ProductDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": data.toJson(),
      };
}

class ProductDetailData {
  int id;
  String name;
  String description;
  String category;
  Dimension dimension;
  Weight weight;
  bool available;
  bool featured;
  bool? customizable;
  List<Selection> selections;
  List<Variant> variant;
  List<ImageModel> images;
  Model model;
  DateTime createdAt;

  ProductDetailData({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.dimension,
    required this.weight,
    required this.available,
    required this.featured,
    this.customizable,
    required this.selections,
    required this.variant,
    required this.images,
    required this.model,
    required this.createdAt,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) =>
      ProductDetailData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        dimension: Dimension.fromJson(json["dimension"]),
        weight: Weight.fromJson(json["weight"]),
        available: json["available"],
        featured: json["featured"],
        customizable: json["customizable"] ?? false,
        selections: List<Selection>.from(
            json["selections"].map((x) => Selection.fromJson(x))),
        variant:
            List<Variant>.from(json["variant"].map((x) => Variant.fromJson(x))),
        images: List<ImageModel>.from(
            json["images"].map((x) => ImageModel.fromJson(x))),
        model: Model.fromJson(json["model"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "dimension": dimension.toJson(),
        "weight": weight.toJson(),
        "available": available,
        "featured": featured,
        "customizable": customizable,
        "selections": List<dynamic>.from(selections.map((x) => x.toJson())),
        "variant": List<dynamic>.from(variant.map((x) => x.toJson())),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "model": model.toJson(),
        "created_at": createdAt.toIso8601String(),
      };
}

class Model {
  String id;
  String name;
  // int? order;
  String url;
  DateTime uploadedAt;

  Model({
    required this.id,
    required this.name,
    // this.order,
    required this.url,
    required this.uploadedAt,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json["id"],
        name: json["name"],
        // order: json["order"],
        url: json["url"],
        uploadedAt: DateTime.parse(json["uploaded_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "order": order,
        "url": url,
        "uploaded_at": uploadedAt.toIso8601String(),
      };
}

class Selection {
  String name;
  List<Option> options;

  Selection({
    required this.name,
    required this.options,
  });

  factory Selection.fromJson(Map<String, dynamic> json) => Selection(
        name: json["name"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  String value;
  String? hexCode;

  Option({
    required this.value,
    this.hexCode,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        value: json["value"],
        hexCode: json["hex_code"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "hex_code": hexCode,
      };
}

class Variant {
  String sku;
  String variantName;
  int price;

  Variant({
    required this.sku,
    required this.variantName,
    required this.price,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        sku: json["sku"],
        variantName: json["variant_name"] ?? "",
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "sku": sku,
        "variant_name": variantName,
        "price": price,
      };
}
