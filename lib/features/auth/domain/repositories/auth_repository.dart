import 'dart:io';

import 'package:drive_driver_bloc/features/auth/data/model/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> signUp(
      String name, String email, String password, String phoneNumber);

  Future<AuthResponse> login(String name, String password);
  Future<AuthResponse> saveDetails(
      String vehicleRC,
      String licenseNumber,
      String vehicleType,
      String driverId,
      File image,
      File licenseImage,
      File permitImage);
}
