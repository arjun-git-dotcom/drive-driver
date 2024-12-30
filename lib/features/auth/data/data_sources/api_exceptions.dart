
class AuthApiException implements Exception {

  final String message;

 
  AuthApiException(this.message);

 
  @override
  String toString() => 'AuthApiException: $message';
}
