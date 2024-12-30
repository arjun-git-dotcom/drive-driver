import 'package:drive_driver_bloc/features/home/data/data_sources/apiservices.dart';
import 'package:drive_driver_bloc/features/home/domain/repositories/rejectride_repository.dart';

class RejectrideRepositoryImpl implements RejectrideRepository {
  final Apiservices apiservices;
  RejectrideRepositoryImpl(this.apiservices);

  @override
  Future<bool> rejectride() {
    print('3');
    return apiservices.rejectride();
  }
}
