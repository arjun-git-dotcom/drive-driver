import 'dart:async';
import 'dart:convert';

import 'package:drive_driver_bloc/core/utils/colors.dart';
import 'package:drive_driver_bloc/features/home/presentation/bloc/driver_bloc.dart';
import 'package:drive_driver_bloc/features/home/presentation/bloc/driver_event.dart';
import 'package:drive_driver_bloc/features/home/presentation/bloc/driver_state.dart';
import 'package:drive_driver_bloc/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

double? startlat;
double? startlong;
double? deslat;
double? deslong;
LatLng? start;
LatLng? dest;
Position? currentPosition;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController mapController = MapController();
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  double? markerlat;
  double? markerlong;

  LatLng? destination;
  IO.Socket? socket;
  bool? isSwitched = false;
  List<LatLng> polylinePoints = [];
  late Timer timer;
  double t = 0;
  double? newLat;
  double? newLong;

  SocketService socketService = SocketService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
    loadSwitchState();
    fetchPosition();
  
  }

  Future<void> loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isSwitched = prefs.getBool('isOnline') ?? false;
    context.read<DriverBloc>().add(DriverToggleUpdated(isSwitched!));
  }

  Future<void> _initializeApp() async {
    await requestLocationPermission();

    socketService.initializeSocket(context, (data) {
      if (isSwitched == true) {
        showRideRequestDialog(context, data);
      } else {
        Fluttertoast.showToast(
            msg: "Ride request ignored as the driver is offline");
      }
    });
  }

  Future<List<LatLng>> fetchRoute(LatLng start, LatLng destination) async {
    final url = Uri.parse(
      'https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?geometries=geojson&access_token=pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final route = data['routes'][0]['geometry']['coordinates'];
        return route
            .map<LatLng>((point) => LatLng(point[1], point[0]))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  Future<void> fetchPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: 'Location Service is disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(msg: 'You denied the permission');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: 'Permission denied permanently');
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      final marker = Marker(
        point: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        child: const Icon(
          Icons.location_on,
          size: 30,
          color: Colors.red,
        ),
      );
      BlocProvider.of<DriverBloc>(context).add(AddMarkerEvent(marker));
      mapController.move(
        LatLng(currentPosition!.latitude, currentPosition!.longitude),
        15.0,
      );

      start = LatLng(currentPosition!.latitude, currentPosition!.longitude);
      startlat = currentPosition!.latitude;
      startlong = currentPosition!.longitude;

      if (placemarks.isNotEmpty) {
        String address =
            "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}";
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching location: $e');
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      Fluttertoast.showToast(msg: 'Location permission granted');
    } else if (status.isDenied) {
      Fluttertoast.showToast(msg: 'Location permission denied');
    } else if (status.isPermanentlyDenied) {
      Fluttertoast.showToast(
          msg:
              'Location permission permanently denied. Enable it in settings.');
      openAppSettings();
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  moveMarker() {
    timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      t = timer.tick / 100;
      if (t >= 1) {
        t = 1;
        timer.cancel();
      }
      newLat = startlat! + (deslat! - startlat!) * t;
      newLong = startlong! + (deslong! - startlong!) * t;

      markerlat = newLat!;
      markerlong = newLong!;

      BlocProvider.of<DriverBloc>(context)
          .add(MovemarkerEvent(markerlat, markerlong));
    });
  }

  void showRideRequestDialog(BuildContext Context, dynamic data) {
    showDialog(
      context: Context,
      builder: (BuildContext dialogContext) {
        print(data);

        return BlocProvider.value(
          value: BlocProvider.of<DriverBloc>(Context),
          child: AlertDialog(
            title: const Text('Ride Request'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    Text(
                      "PickUpLocation: ${data['pickUpLocation']} ",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                    Text("dropOffLocation: ${data['dropOffLocation']}"),
                  ],
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  BlocProvider.of<DriverBloc>(context).add(RejectRideEvent());
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Reject'),
              ),
              TextButton(
                onPressed: () async {
                  dest = const LatLng(9.938299186302348, 76.32187566853835);
                 
                  print(start);
                  print(dest);
                  BlocProvider.of<DriverBloc>(context)
                      .add(UpdatePolylineEvent(start!, dest!));

                  BlocProvider.of<DriverBloc>(context).add(AcceptRideEvent());
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('trip_id', data['_id']);

                  BlocProvider.of<DriverBloc>(dialogContext)
                      .add(AcceptRideEvent());
                  fetchRoute(start!, dest!);

                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Accept'),
              ),
            ],
          ),
        );
      },
    );
  }

  // void startNavigation(dynamic data) {
  //   markers.clear();
  //   final marker = Marker(
  //     point: LatLng(data['pickUpCoords'][1], data['pickUpCoords'][0]),
  //     child: const Icon(Icons.person_pin_circle, color: Colors.red),
  //   );
  //   BlocProvider.of<DriverBloc>(context).add(AddMarkerEvent(marker));
  //   final markertwo = Marker(
  //     point: LatLng(data['dropCoords'][1], data['dropCoords'][0]),
  //     child: const Icon(Icons.flag, color: Colors.green),
  //   );
  //   BlocProvider.of<DriverBloc>(context).add(AddMarkerEvent(markertwo));

  //   mapController.move(
  //     LatLng(data['pickUpCoords'][1], data['pickUpCoords'][0]),
  //     15.0,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          BlocBuilder<DriverBloc, DriverState>(
            builder: (context, state) {
              bool isSwitched = false;
              if (state is DriverAndMapState && state.isSwitched != null) {
                isSwitched = state.isSwitched!;
              }
              return Switch(
                value: isSwitched,
                onChanged: (value) {
                  context.read<DriverBloc>().add(DriverToggleUpdated(value));

                  showToast(
                      value ? "Driver is now online" : "Driver is now offline");
                },
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 400,
              child: BlocBuilder<DriverBloc, DriverState>(
                  builder: (context, state) {
                if (state is DriverAndMapState) {
                  print('state IS $state');
                  print('marker is ${state.markers}');

                  return FlutterMap(
                    mapController: mapController,
                    options: const MapOptions(
                      initialCenter:
                          LatLng(9.920365269719332, 76.31706818149196),
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      PolylineLayer<Object>(
                        polylines: state.polylines ?? [],
                        cullingMargin: 10,
                        minimumHitbox: 10,
                      ),
                      MarkerLayer(markers: state.markers ?? []),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
