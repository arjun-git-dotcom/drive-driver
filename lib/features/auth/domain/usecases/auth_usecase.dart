import 'package:drive_driver_bloc/features/auth/data/model/auth_response.dart';
import 'package:drive_driver_bloc/features/auth/domain/entities/user.dart';
import 'package:drive_driver_bloc/features/auth/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;
  AuthUseCase({required this.repository});

  Future<AuthResponse> signupcall(User user) async {
    return await repository.signUp(
        user.name, user.email, user.password, user.phoneNumber);
  }

  Future<AuthResponse> logincall(Userlogin userlogin) async {
    return await repository.login(userlogin.email, userlogin.password);
  }

  Future<AuthResponse> saveDetailscall(UserSaveDetails userSaveDetails) async {
    return await repository.saveDetails(
        userSaveDetails.vehicleRC,
        userSaveDetails.licenseNumber,
        userSaveDetails.vehicleType,
        userSaveDetails.driverId,
        userSaveDetails.image,
        userSaveDetails.licenseImage,
        userSaveDetails.permitImage);
  }
}
