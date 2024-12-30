import 'dart:io';

abstract class AuthEvent {}

class AuthReqtoLogin extends AuthEvent {
  final String username;
  final String password;
  final String email;
  final String phoneNumber;
  AuthReqtoLogin(
      {required this.username,
      required this.password,
      required this.email,
      required this.phoneNumber});
}

class AuthEntryAllowed extends AuthEvent {}

class AuthPending extends AuthEvent {}

class AuthLoginDataEntry extends AuthEvent {
  String email;
  String password;

  AuthLoginDataEntry({
    required this.email,
    required this.password,
  });
}

class CheckLogin extends AuthEvent {}

class NameChanged extends AuthEvent {}

class EmailChanged extends AuthEvent {}

class PasswordChanged extends AuthEvent {}

class PhoneChanged extends AuthEvent {}

class DetailsPage extends AuthEvent {
  File? imageType;
  DetailsPage([this.imageType]);
}


class AuthSaveDetails extends AuthEvent {
  String vehicleRC;
  String licenseNumber;
  String vehicleType;
  String driverId;
  File image;
  File licenseImage;
  File permitImage;

  AuthSaveDetails(
      {required this.vehicleRC,
      required this.licenseNumber,
      required this.vehicleType,
      required this.driverId,
      required this.image,
      required this.licenseImage,
      required this.permitImage});
}
