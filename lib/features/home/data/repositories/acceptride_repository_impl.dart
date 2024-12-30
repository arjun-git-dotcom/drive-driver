import 'package:drive_driver_bloc/features/home/data/data_sources/apiservices.dart';
import 'package:drive_driver_bloc/features/home/domain/repositories/accepteide_repository.dart';

class AcceptrideRepositoryImpl implements AcceptRideRepository {
  final Apiservices apiservices;
  AcceptrideRepositoryImpl(this.apiservices);

  @override
  Future<bool> acceptride() {
     print('3');
    return apiservices.acceptride();
  }
}
