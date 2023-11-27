// class UserData {
//   String sessionId;
//   String accessToken;
//   DateTime accessTokenExpiresAt;
//   String refreshToken;
//   DateTime refreshTokenExpiresAt;
//   UserClass user;

//   UserData({
//     required this.sessionId,
//     required this.accessToken,
//     required this.accessTokenExpiresAt,
//     required this.refreshToken,
//     required this.refreshTokenExpiresAt,
//     required this.user,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) => UserData(
//         sessionId: json["session_id"],
//         accessToken: json["access_token"],
//         accessTokenExpiresAt: DateTime.parse(json["access_token_expires_at"]),
//         refreshToken: json["refresh_token"],
//         refreshTokenExpiresAt: DateTime.parse(json["refresh_token_expires_at"]),
//         user: UserClass.fromJson(json["user"]), // Parse user object separately
//       );
// }

// class UserClass {
//   String id;
//   String name;
//   String email;
//   String role;
//   String phone;
//   String birthdate;
//   dynamic profilePicture;
//   String gender;
//   DateTime createdAt;
//   dynamic passwordChangedAt;

//   UserClass({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.role,
//     required this.phone,
//     required this.birthdate,
//     required this.profilePicture,
//     required this.gender,
//     required this.createdAt,
//     required this.passwordChangedAt,
//   });

//   factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         role: json["role"],
//         phone: json["phone"],
//         birthdate: json["birthdate"],
//         profilePicture: json["profile_picture"] ?? '',
//         gender: json["gender"],
//         createdAt: DateTime.parse(json["created_at"]),
//         passwordChangedAt: json["password_changed_at"] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "role": role,
//         "phone": phone,
//         "birthdate": birthdate,
//         "profile_picture": profilePicture,
//         "gender": gender,
//         "created_at": createdAt.toIso8601String(),
//         "password_changed_at": passwordChangedAt,
//       };
// }
class LoginResponse {
  int code;
  String status;
  LoginData data;

  LoginResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: json["code"],
        status: json["status"],
        data: LoginData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": data.toJson(),
      };
}

class LoginData {
  String sessionId;
  String accessToken;
  DateTime accessTokenExpiresAt;
  String refreshToken;
  DateTime refreshTokenExpiresAt;
  UserData user;

  LoginData({
    required this.sessionId,
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        sessionId: json["session_id"],
        accessToken: json["access_token"],
        accessTokenExpiresAt: DateTime.parse(json["access_token_expires_at"]),
        refreshToken: json["refresh_token"],
        refreshTokenExpiresAt: DateTime.parse(json["refresh_token_expires_at"]),
        user: UserData.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "access_token": accessToken,
        "access_token_expires_at": accessTokenExpiresAt.toIso8601String(),
        "refresh_token": refreshToken,
        "refresh_token_expires_at": refreshTokenExpiresAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class UserData {
  String id;
  String name;
  String email;
  String role;
  String phone;
  String birthdate;
  dynamic profilePicture;
  String gender;
  DateTime createdAt;
  dynamic passwordChangedAt;
  String accessToken; // Add this field
  String refreshToken; // Add this field

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.birthdate,
    required this.profilePicture,
    required this.gender,
    required this.createdAt,
    required this.passwordChangedAt,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        phone: json["phone"],
        birthdate: json["birthdate"],
        profilePicture: json["profile_picture"],
        gender: json["gender"],
        createdAt: DateTime.parse(json["created_at"]),
        passwordChangedAt: json["password_changed_at"],
        accessToken: "", // Initialize with empty strings
        refreshToken: "", // Initialize with empty strings
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
        "birthdate": birthdate,
        "profile_picture": profilePicture,
        "gender": gender,
        "created_at": createdAt.toIso8601String(),
        "password_changed_at": passwordChangedAt,
      };
}
