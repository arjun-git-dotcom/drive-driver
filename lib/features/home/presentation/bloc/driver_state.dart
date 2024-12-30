import 'package:flutter_map/flutter_map.dart';

abstract class DriverState {}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverSocketInitialized extends DriverState {}

class RideRequestState extends DriverState {
  Map<String, dynamic> rideDetails;
  RideRequestState(this.rideDetails);
}

class RideAcceptedState extends DriverState {
  final String userId;
  RideAcceptedState(this.userId);
}

class DriverOnlineFailure extends DriverState {
  DriverOnlineFailure(String string);
}

// class MapInitial extends DriverState {}

// class MapUpdated extends DriverState {
//   final List<Marker> markers;
//   final List<Polyline> polylines;
//   MapUpdated(this.markers, this.polylines);
// }

// class DriverSwitchUpdated extends DriverState {
//   final bool isSwitched;
//   DriverSwitchUpdated(this.isSwitched);
// }

class DriverAndMapState extends DriverState {
  final bool? isSwitched;
  final List<Marker>? markers;
  final List<Polyline<Object>>? polylines;

  DriverAndMapState({this.isSwitched, this.markers =const [], this.polylines=const[]});

  DriverAndMapState copyWith({bool? isSwitched, List<Marker>? markers, List<Polyline>? polylines,}
) {
    return DriverAndMapState(
      isSwitched: isSwitched ?? this.isSwitched,
      markers: markers ?? this.markers,
polylines: polylines??this.polylines
    );
  }
}

class PolylineError extends DriverState {
  final String error;

  PolylineError(this.error);
}

class AcceptRouteState extends DriverState {}

class TravelRouteState extends DriverState {}

class Movemarker extends DriverState {
  double? markerlat;
  double? markerlong;
  Movemarker(this.markerlat, this.markerlong);
}
