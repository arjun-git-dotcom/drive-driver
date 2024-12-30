import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_state.dart';
import 'package:drive_driver_bloc/features/auth/presentation/screens/authscreen.dart';
import 'package:drive_driver_bloc/features/auth/data/data_sources/api_services.dart';
import 'package:drive_driver_bloc/features/auth/presentation/screens/detailsScreen.dart';
import 'package:drive_driver_bloc/features/auth/presentation/screens/otpscreen.dart';
import 'package:drive_driver_bloc/features/home/data/data_sources/apiservices.dart';
import 'package:drive_driver_bloc/features/home/presentation/bloc/driver_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:drive_driver_bloc/features/auth/presentation/screens/logindataEntry.dart';
import 'package:drive_driver_bloc/features/auth/presentation/screens/pendingScreen.dart';
import 'package:drive_driver_bloc/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DriverBloc(apiService: Apiservices()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authServices: AuthApiService(client: http.Client()),
          ),
        ),
      ],
      child: MaterialApp(
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DetailspageState) {
              return const Detailsscreen();
            } else if (state is AuthOtp) {
              return const Otpscreen();
            } else if (state is AuthPendingState) {
              return const Logindataentry();
            } else if (state is AuthLoginEntryDataState) {
              return const Pendingscreen();
            } else if (state is HomescreenState) {
              return const HomeScreen();
            } else if (state is AuthUnAuthenticated) {
              return const Authscreen();
            }
            return const Authscreen();
          },
        ),
      ),
    );
  }
}
