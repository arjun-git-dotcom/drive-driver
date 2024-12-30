import 'package:drive_driver_bloc/features/home/data/data_sources/apiservices.dart';
import 'package:drive_driver_bloc/features/home/domain/entities/toggle_status.dart';
import 'package:drive_driver_bloc/features/home/domain/repositories/toggle_repository.dart';

class ToggleRepositoryImpl implements ToggleRepository {
  final Apiservices apiService;
  ToggleRepositoryImpl(this.apiService);

  @override
  Future<bool> setToggleStatus(ToggleStatus status) {
    return apiService.sendToggleStatus(status.isOn);
  }
}
