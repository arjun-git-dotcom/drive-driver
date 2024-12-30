import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drive_driver_bloc/core/config.dart';
import 'package:drive_driver_bloc/features/auth/data/data_sources/api_exceptions.dart';
import 'package:drive_driver_bloc/features/auth/data/model/auth_response.dart';
import 'package:http/http.dart' as http;

String? cookie;

class AuthApiService {
  final http.Client client;

  AuthApiService({required this.client});

  Future<AuthResponse> signUp(Map<String, String> userDetails) async {
    final response = await client.post(
      Uri.parse('$baseurl/auth/driver/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userDetails),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      cookie = response.headers['set-cookie'];
      print(cookie);
      return AuthResponse.fromJson(data);
    } else {
      throw AuthApiException('Failed to sign up: ${response.body}');
    }
  }

  Future<AuthResponse> saveDetails({
    required String vehicleRC,
    required String licenseNumber,
    required String vehicleType,
    required String driverId,
    File? image,
    File? licenseImage,
    File? permitImage,
  }) async {
    final url = Uri.parse('$baseurl/auth/driver/complete-profile');
    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['licenseNumber'] = licenseNumber
        ..fields['vehicleType'] = vehicleType
        ..fields['driverId'] = driverId
        ..fields['vehicleRC'] = vehicleRC;

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('ProfileImg', image.path),
        );
      }
      if (licenseImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('licensePhoto', licenseImage.path),
        );
      }
      if (permitImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('permit', permitImage.path),
        );
      }

      final response =
          await request.send().timeout(const Duration(seconds: 15));
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseData.body);
        return AuthResponse.fromJson(data);
      } else {
        throw AuthApiException('Failed to save details: ${responseData.body}');
      }
    } on http.ClientException catch (e) {
      throw AuthApiException('Network error: ${e.message}');
    } on TimeoutException {
      throw AuthApiException('Request timed out. Please try again later.');
    } catch (e) {
      throw AuthApiException('An unexpected error occurred: $e');
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse('$baseurl/auth/driver/login');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      final authResponse = AuthResponse.fromJson(data);

      return authResponse;
    } else {
      throw AuthApiException('Login failed: ${response.body}');
    }
  }
}
