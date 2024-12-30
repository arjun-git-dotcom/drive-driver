import 'dart:io';

import 'package:drive_driver_bloc/features/auth/data/data_sources/api_exceptions.dart';
import 'package:drive_driver_bloc/features/auth/data/data_sources/api_services.dart';
import 'package:drive_driver_bloc/features/auth/data/model/auth_response.dart';
import 'package:drive_driver_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final SharedPreferences prefs;

  AuthRepositoryImpl({required this.apiService, required this.prefs});

  @override
  Future<AuthResponse> signUp(String username, String password, String email,
      String phoneNumber) async {
    final userDetails = {
      'name': username,
      'email': email,
      'phone': phoneNumber,
      'password': password,
    };

    try {
      final response = await apiService.signUp(userDetails);
      final msg = response.token ?? '';
      prefs.setString('signup_token', msg);
      return AuthResponse(message: msg);
    } catch (error) {
      throw AuthApiException('SignUp failed: $error');
    }
  }

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await apiService.login(email, password);

      final token = response.token ?? '';
      final msg = response.message ?? '';
      prefs.setString('login_token', token);
      return AuthResponse(token: response.token, message: msg);
    } catch (error) {
      throw AuthApiException('Login failed $error');
    }
  }
@override
  Future<AuthResponse> saveDetails(
      String vehicleRC,
      String licenseNumber,
      String vehicleType,
      String driverId,
      File image,
      File licenseImage,
      File permitImage) async {
    try {
      final response = await apiService.saveDetails(
          vehicleRC: vehicleRC,
          licenseNumber: licenseNumber,
          vehicleType: vehicleType,
          driverId: driverId);
      final msg = response.token ?? '';
      return AuthResponse(message: msg);
    } catch (error) {
      throw AuthApiException('Failed to save Details $error');
    }
  }
}
