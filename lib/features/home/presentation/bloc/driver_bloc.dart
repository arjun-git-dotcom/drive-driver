import 'package:drive_driver_bloc/features/home/data/data_sources/apiservices.dart';
import 'package:drive_driver_bloc/features/home/data/repositories/acceptride_repository_impl.dart';
import 'package:drive_driver_bloc/features/home/data/repositories/rejectride_repository_impl.dart';
import 'package:drive_driver_bloc/features/home/data/repositories/toggle_repository_impl.dart';
import 'package:drive_driver_bloc/features/home/domain/entities/toggle_status.dart';
import 'package:drive_driver_bloc/features/home/domain/usecase/acceptride_usecase.dart';
import 'package:drive_driver_bloc/features/home/domain/usecase/rejectride_usecase.dart';
import 'package:drive_driver_bloc/features/home/domain/usecase/toggle_usecase.dart';
import 'package:drive_driver_bloc/features/home/presentation/bloc/driver_event.dart';
import 'package:drive_driver_bloc/features/home/presentation/bloc/driver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  final Apiservices apiService;
  DriverBloc({required this.apiService})
      : super(DriverAndMapState(isSwitched: false, markers: [])) {
    // on<DriverOnline>((event, emit) async {
    //   emit(DriverLoading());
    //   try {
    //     SetToggleUseCase toggleusecase =
    //         SetToggleUseCase(repository: ToggleRepositoryImpl(apiService));
    //     final result = await toggleusecase.call(event.status);
    //     emit(DriverOnlineSuccess(isOnline: result));
    //   } catch (error) {
    //     emit(DriverOnlineFailure(error.toString()));
    //   }
    // });


    on<AcceptRouteEvent>((event, emit) {
      emit(AcceptRouteState());
    });

    on<TravelRouteEvent>((event, emit) {
      emit(TravelRouteState());
    });
    on<AcceptRideEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      AcceptRideUseCase acceptRideUseCase = AcceptRideUseCase(
          acceptRideRepository: AcceptrideRepositoryImpl(apiService));
      print('1');
      print(prefs.getString('trip_id'));
      final result = await acceptRideUseCase.call();
    });

    on<RejectRideEvent>((event, emit) async {
      RejectrideUsecase rejectrideUsecase =
          RejectrideUsecase(RejectrideRepositoryImpl(apiService));
      print('1');
      final result = await rejectrideUsecase.call();
    });

    on<DriverToggleUpdated>((event, emit) async {
      final currentState = state;
      if (currentState is DriverAndMapState) {
        emit(DriverAndMapState(isSwitched: event.isSwitched));
        SetToggleUseCase setToggleUseCase =
            SetToggleUseCase(repository: ToggleRepositoryImpl(apiService));
   
        final success =
            await setToggleUseCase.call(ToggleStatus(isOn: event.isSwitched));

        if (!success) {
         
          emit(DriverAndMapState(isSwitched: !event.isSwitched));
        }
       
      }
    });

    on<AddMarkerEvent>((event, emit) {
      final currentState = state;
      if (currentState is DriverAndMapState) {
        final updatedMarkers = List<Marker>.from(currentState.markers??[])
          ..add(event.marker);
        emit(currentState.copyWith(markers: updatedMarkers));
      }
    });

    Future<List<LatLng>> fetchRoute(LatLng start, LatLng destination) async {
      await Future.delayed(
          const Duration(seconds: 1)); 
      return [
        start,
        LatLng((start.latitude + destination.latitude) / 2,
            (start.longitude + destination.longitude) / 2),
        destination
      ];
    }

    on<UpdatePolylineEvent>((event, emit) async {
      try {
        final route = await fetchRoute(event.start, event.destination);
        final polyline = [
          Polyline<Polyline<Object>>(
            points: route,
            strokeWidth: 15.0,
            color: Colors.blue,
          ),
        ];
         final currentState = state;
    if (currentState is DriverAndMapState) {
      final updatedMarkers = currentState.markers ?? [];
      
     
      emit(currentState.copyWith(
        markers: updatedMarkers,  
        polylines: polyline,      
      ));
    }
      } catch (e) {
        emit(PolylineError("Failed to fetch route"));
      }
    });

    on<MovemarkerEvent>((event, emit) {
      emit(DriverAndMapState());
    });
  }
}
