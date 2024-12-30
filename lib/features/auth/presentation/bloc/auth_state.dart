import 'dart:io';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnAuthenticated extends AuthState {}

class AuthOtp extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

class DetailspageState extends AuthState {
   File? licenseImage;
  File? permitImage;
  DetailspageState([this.licenseImage, this.permitImage]);
}

class AuthPendingState extends AuthState {}

class AuthLoginEntryDataState extends AuthState {}

class PendingpageState extends AuthState {}

class HomescreenState extends AuthState {}


