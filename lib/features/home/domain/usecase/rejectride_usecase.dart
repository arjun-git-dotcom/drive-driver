import 'package:drive_driver_bloc/features/home/domain/repositories/rejectride_repository.dart';

class RejectrideUsecase {
  final RejectrideRepository rejectRideRepository;
  RejectrideUsecase(this.rejectRideRepository);
  Future<bool> call() {
    print('2');
    return rejectRideRepository.rejectride();
  }
}
