import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

import '../model/profile_model.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  UserProfileState _state = UserProfileState.Loading;

  UserProfile? get userProfile => _userProfile;
  UserProfileState get state => _state;

  Future<void> fetchUserProfile() async {
    _state = UserProfileState.Loading;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        _userProfile = UserProfile.fromJson(responseData);
        _state = UserProfileState.Loaded;
      } else {
        _state = UserProfileState.Error;
      }
    } catch (error) {
      _state = UserProfileState.Error;
    }

    notifyListeners();
  }

  Future<void> updateUserProfile(
      {String? name, String? phone, String? gender, String? date}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    debugPrint(
        'token from edit profile: ${SharedPreferences.getInstance().then((value) => value.getString('access_token'))}');
    final response = await http.patch(
      Uri.parse('$baseUrl/users/profile'),
      body: jsonEncode({
        "name": name,
        "gender": gender,
        "phone": phone,
        "birthdate": date,
      }),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body)['data'];
      debugPrint('responseData from edit profile: $responseData');
      _userProfile = UserProfile.fromJson(responseData);
      notifyListeners();
    } else {
      final responseBody = jsonDecode(response.body)['errors'];
      final errorMessage = responseBody['message'];
      debugPrint('[edit profile error ] $errorMessage');
      throw Exception(errorMessage);
    }
  }

  Future<void> updateProfilePicture(String uploadId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final uri = Uri.parse('$baseUrl/users/profile-image');
      final response = await http.post(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json',
        },
        body: json.encode({'upload_id': uploadId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        debugPrint('responseData from update profil pict: $responseData');

        debugPrint('Profile picture updated');
      } else {
        debugPrint(
            'Failed to update profile picture. Status Code: ${response.statusCode}');
        throw Exception('Failed to update profile picture');
      }
    } catch (error) {
      throw Exception('Failed to update profile picture: $error');
    }
  }
}

class ImageUploadProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String? _uploadedImageId; // Initialize as null

  String? get uploadedImageId => _uploadedImageId;

  void setUploadedImageId(String id) {
    _uploadedImageId = id;
    notifyListeners();
  }

  Future<ImageUploadResponse> uploadImage(File imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final uri = Uri.parse('$baseUrl/uploads/users/images');
      var request = http.MultipartRequest('POST', uri);

      var multipartFile = http.MultipartFile(
          'file', imagePath.openRead(), await imagePath.length(),
          filename: basename(imagePath.path));

      request.headers
          .addAll({HttpHeaders.authorizationHeader: "Bearer $token"});
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var imageUploadResponse = ImageUploadResponse.fromJson(
            json.decode(utf8.decode(responseData))['data']);
        setUploadedImageId(imageUploadResponse.id);

        debugPrint('imageUploadResponse: $imageUploadResponse.toString()');
        return imageUploadResponse;
      } else {
        debugPrint(
            'Failed to upload image. Status Code: ${response.statusCode}');
        throw Exception('Failed to upload image');
      }
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }
}
