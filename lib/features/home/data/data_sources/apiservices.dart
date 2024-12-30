import 'dart:convert';

import 'package:drive_driver_bloc/core/config.dart';
import 'package:drive_driver_bloc/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Apiservices {
  Future<bool> rejectride() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response =
        await http.post(Uri.parse('$baseurl/trip/driver/reject-ride'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${prefs.getString('login_token')}'
            },
            body: jsonEncode({
              'driverId': '673b32b3305f4b93cb8304dd',
              'status': 'rejected',
              'tripId': prefs.getString('trip_id'),
            }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> acceptride() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response =
        await http.post(Uri.parse('$baseurl/trip/driver/accept-ride'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${prefs.getString('login_token')}'
            },
            body: jsonEncode({
              'driverId': '673b32b3305f4b93cb8304dd',
              'status': 'accepted',
              'tripId': prefs.getString('trip_id'),
            }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendToggleStatus(bool isOn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  
   
    final body = jsonEncode({
      "driverId": "673ac491f9f50c2b6d57588b",
      'location': [startlong, startlat]
    });
    final response = await http.put(Uri.parse('$baseurl/trip/driver/online'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('login_token')}'
        },
        body: body);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201) {
         prefs.setBool('isOnline', isOn);
      return true;
    } else {
      return false;
    }
  }
}
