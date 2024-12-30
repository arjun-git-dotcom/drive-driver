class AuthResponse {
  final String? message;
  final String? token;
  AuthResponse({this.message, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(message: json['message'], token: json['accessToken']);
  }
}

class SaveDetailsResponse {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String licenseNumber;
  final String vehicleType;
  final String rcNumber;
  final bool isComplete;
  final String licenceUrl;
  final String profileUrl;
  SaveDetailsResponse(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.licenseNumber,
      required this.vehicleType,
      required this.rcNumber,
      required this.isComplete,
      required this.licenceUrl,
      required this.profileUrl});

  factory SaveDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SaveDetailsResponse(
        id: json['data']['_id'],
        name: json['data']['name'],
        email: json['data']['email'],
        phone: json['data']['phone'],
        licenseNumber: json['data']['licenseNumber'],
        vehicleType: json['data']['vehicleType'],
        rcNumber: json['data']['rcNumber'],
        isComplete: json['data']['isComplete'],
        licenceUrl: json['data']['licenseUrl'],
        profileUrl: json['data']['profileUrl']);
  }
}
