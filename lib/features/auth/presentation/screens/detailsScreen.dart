import 'dart:io';

import 'package:drive_driver_bloc/core/utils/colors.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController licenseController = TextEditingController();
TextEditingController vehicleTypeController = TextEditingController();
TextEditingController driverIdController = TextEditingController();
TextEditingController rcController = TextEditingController();

class Detailsscreen extends StatefulWidget {
  const Detailsscreen({super.key});

  @override
  State<Detailsscreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Detailsscreen> {
  File? image;
  File? licenseImage;
  File? permitImage;
  final imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> pickImage(context) async {
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image = File(pickedImage.path);

      BlocProvider.of<AuthBloc>(context).add(DetailsPage(image));
    }
  }

  Future<void> camera(String imagePath, context) async {
    final imageCaptured =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (imageCaptured != null) {
      if (imagePath == 'license') {
        licenseImage = File(imageCaptured.path);
        BlocProvider.of<AuthBloc>(context).add(DetailsPage(licenseImage));
      } else if (imagePath == 'permit') {
        permitImage = File(imageCaptured.path);
        BlocProvider.of<AuthBloc>(context).add(DetailsPage(permitImage));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is DetailspageState) {
              return Container(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.black,
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              pickImage(context);
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  image != null ? FileImage(image!) : null,
                              backgroundColor: AppColors.grey200,
                              child: image == null
                                  ? const Icon(Icons.add_a_photo,
                                      size: 50, color: Colors.black)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildTextField(
                            'Enter your License Number',
                            licenseController,
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            'Vehicle Type',
                            vehicleTypeController,
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            'Enter your Vehicle RC Number',
                            rcController,
                          ),
                          const SizedBox(height: 20),
                          _buildUploadButton(
                            context,
                            'Upload License Image',
                            'license',
                          ),
                          const SizedBox(height: 15),
                          _buildUploadButton(
                            context,
                            'Upload Vehicle Permit',
                            'permit',
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: () async {
                                final bloc = BlocProvider.of<AuthBloc>(context);
                                bloc.add(AuthPending());

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String id = prefs.getString('id') ?? '';

                                bloc.add(AuthSaveDetails(
                                  vehicleRC: rcController.text,
                                  licenseNumber: licenseController.text,
                                  vehicleType: vehicleTypeController.text,
                                  driverId: id,
                                  image: image!,
                                  licenseImage: licenseImage!,
                                  permitImage: permitImage!,
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 100,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Save Details',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildUploadButton(
      BuildContext context, String label, String imagePath) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton.icon(
        onPressed: () async => await camera(imagePath, context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: const Icon(Icons.camera_alt, color: Colors.black),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
