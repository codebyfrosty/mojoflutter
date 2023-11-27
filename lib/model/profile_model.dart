class UserProfile {
  final String id;
  String name;
  String email;
  String role;
  String phone;
  String birthdate;
  String gender;
  String createdAt;
  ProfilePicture profilePicture;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.birthdate,
    required this.gender,
    required this.createdAt,
    required this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      birthdate: json['birthdate'],
      gender: json['gender'],
      createdAt: json['created_at'],
      profilePicture: ProfilePicture.fromJson(json['profile_picture']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'birthdate': birthdate,
      'gender': gender,
      'created_at': createdAt,
    };
  }
}

class ProfilePicture {
  String name;
  String url;
  DateTime uploadedAt;

  ProfilePicture({
    required this.name,
    required this.url,
    required this.uploadedAt,
  });

  factory ProfilePicture.fromJson(Map<String, dynamic> json) => ProfilePicture(
        name: json["name"],
        url: json["url"],
        uploadedAt: DateTime.parse(json["uploaded_at"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "uploaded_at": uploadedAt.toIso8601String(),
      };
}

class ImageUploadResponse {
  final String id;
  final String fileName;
  final String imageUrl;
  final String contentType;

  ImageUploadResponse({
    required this.id,
    required this.fileName,
    required this.imageUrl,
    required this.contentType,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      id: json['id'],
      fileName: json['file_name'],
      imageUrl: json['image_url'],
      contentType: json['content_type'],
    );
  }
}
