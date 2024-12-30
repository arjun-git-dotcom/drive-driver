import 'package:drive_driver_bloc/features/home/domain/entities/toggle_status.dart';

abstract class ToggleRepository {
  Future<bool> setToggleStatus(ToggleStatus status);
}
