import 'package:drive_driver_bloc/features/home/domain/repositories/accepteide_repository.dart';

class AcceptRideUseCase {
  final AcceptRideRepository acceptRideRepository;
  AcceptRideUseCase({required this.acceptRideRepository});
  Future<bool> call() {
    print('2');
    return acceptRideRepository.acceptride();
  }
}
