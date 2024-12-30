import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

abstract class DriverEvent {}

class InitialSocketEvent extends DriverEvent {}

class RideRequestReceivedEvent extends DriverEvent {
  final Map<String, dynamic> rideDetails;
  RideRequestReceivedEvent({required this.rideDetails});
}

class AcceptRideEvent extends DriverEvent {}

class RejectRideEvent extends DriverEvent {}

class AddMarkerEvent extends DriverEvent {
  final Marker marker;
  AddMarkerEvent(this.marker);
}

class DriverToggleUpdated extends DriverEvent {
  final bool isSwitched;
  DriverToggleUpdated(this.isSwitched);
}

class UpdateRouteEvents extends DriverEvent {
  final List<LatLng> polylinePoints;
  UpdateRouteEvents(this.polylinePoints);
}

class UpdatePolylineEvent extends DriverEvent {
  final LatLng start;
  final LatLng destination;

  UpdatePolylineEvent(this.start, this.destination);
}

class AcceptRouteEvent extends DriverEvent {}

class TravelRouteEvent extends DriverEvent {}

class MovemarkerEvent extends DriverEvent {
  double? markerlat;
  double? markerlong;
  MovemarkerEvent(this.markerlat, this.markerlong);
}
