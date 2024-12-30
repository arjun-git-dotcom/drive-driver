import 'dart:convert';
import 'package:drive_driver_bloc/core/config.dart';
import 'package:drive_driver_bloc/core/utils/colors.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:drive_driver_bloc/features/auth/presentation/screens/authscreen.dart';
import 'package:drive_driver_bloc/features/auth/data/data_sources/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Otpscreen extends StatefulWidget {
  const Otpscreen({super.key});

  @override
  State<Otpscreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Otpscreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColors.black),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Verify OTP',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green),
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter the OTP sent to your email',
                  style: TextStyle(fontSize: 16, color: AppColors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildTextField(
                  controller: otpController,
                  hint: 'Enter OTP',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    BlocProvider.of<AuthBloc>(context).add(AuthEntryAllowed());
                    final response = await http.post(
                      Uri.parse('$baseurl/auth/driver/verify-otp'),
                      body: {"otp": otpController.text},
                      headers: {'Cookie': cookie!},
                    );

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      final data = jsonDecode(response.body);
                      print(data);
                      final msg = data['message'];
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('msg', msg);

                      print(msg);
                      String id = data['data']['_id'];
                      print('the id is $id');

                      prefs.setString('id', id);
                      print(prefs.getString('id'));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 130, vertical: 10),
                    backgroundColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    final response = await http.post(
                      Uri.parse('$baseurl/auth/driver/resend-otp'),
                      body: {"email": emailController.text},
                    );

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      final data = jsonDecode(response.body);
                      print(data['message']);
                    }
                  },
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.black54),
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
