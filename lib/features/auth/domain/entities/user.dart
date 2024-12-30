import 'dart:io';

class User {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  User(
      {required this.name,
      required this.email,
      required this.password,
      required this.phoneNumber});
}

class Userlogin {
  final String email;
  final String password;
  Userlogin({required this.email, required this.password});
}

class UserSaveDetails {
  final String vehicleRC;
  final String licenseNumber;
  final String vehicleType;
  final String driverId;
  final File image;
  final File licenseImage;
  final File permitImage;

  UserSaveDetails(
      {required this.vehicleRC,
      required this.licenseNumber,
      required this.vehicleType,
      required this.driverId,
      required this.image,
      required this.licenseImage,
      required this.permitImage});
}
