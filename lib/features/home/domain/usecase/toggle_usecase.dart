import 'package:drive_driver_bloc/features/home/domain/entities/toggle_status.dart';
import 'package:drive_driver_bloc/features/home/domain/repositories/toggle_repository.dart';

class SetToggleUseCase {
  final ToggleRepository repository;

  SetToggleUseCase({required this.repository});

  Future<bool> call(ToggleStatus status) {
    return repository.setToggleStatus(status);
  }
}
