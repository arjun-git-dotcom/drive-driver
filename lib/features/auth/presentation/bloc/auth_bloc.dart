import 'package:drive_driver_bloc/core/utils/validateutils.dart';
import 'package:drive_driver_bloc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:drive_driver_bloc/features/auth/domain/entities/user.dart';
import 'package:drive_driver_bloc/features/auth/domain/usecases/auth_usecase.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_state.dart';
import 'package:drive_driver_bloc/features/auth/data/data_sources/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApiService authServices;

  AuthBloc({
    required this.authServices,
  }) : super(AuthInitial()) {
    on<AuthReqtoLogin>(
      (event, emit) async {
        final nameError = ValidationUtils.validateName(event.username);
        final emailError = ValidationUtils.validateEmail(event.email);
        final passwordError = ValidationUtils.validatePassword(event.password);
        final phoneError = ValidationUtils.validatePhone(event.phoneNumber);

        List<String> errors = [];
        if (nameError != null) errors.add(nameError);
        if (emailError != null) errors.add(emailError);
        if (passwordError != null) errors.add(passwordError);
        if (phoneError != null) errors.add(phoneError);

        if (errors.isNotEmpty) {
          emit(AuthError(message: errors.join("\n")));
          return;
        }

        emit(AuthLoading());
        final user = User(
            name: event.username,
            email: event.email,
            password: event.password,
            phoneNumber: event.phoneNumber);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        AuthUseCase authUseCase = AuthUseCase(
            repository: AuthRepositoryImpl(
                apiService: AuthApiService(client: http.Client()),
                prefs: prefs));

        final token = await authUseCase.signupcall(user);

        emit(AuthOtp());
      },
    );

    on<DetailsPage>((event, emit) {
      emit(DetailspageState());
    });

    on<AuthEntryAllowed>((event, emit) async {
      emit(DetailspageState());
    });

    on<AuthPending>((event, emit) {
      emit(AuthPendingState());
    });

    on<AuthLoginDataEntry>((event, emit) async {
      final loginuser = Userlogin(email: event.email, password: event.password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      AuthUseCase authUseCase = AuthUseCase(
          repository: AuthRepositoryImpl(
              apiService: AuthApiService(client: http.Client()), prefs: prefs));
      final token = await authUseCase.logincall(loginuser);

      print('the token is $token');

      // if (prefs.getString('loginToken')) {
      //   emit(AuthLoginEntryDataState());
      // }

      //  else
      print(prefs.getString('login_token'));

      if (prefs.getString('login_token') != null) {
        emit(HomescreenState());
      } else {
        emit(AuthUnAuthenticated());
      }
    });

    on<AuthSaveDetails>((event, emit) async {
      final usersaveDetails = UserSaveDetails(
          vehicleRC: event.vehicleRC,
          licenseNumber: event.licenseNumber,
          vehicleType: event.vehicleType,
          driverId: event.driverId,
          image: event.image,
          licenseImage: event.licenseImage,
          permitImage: event.permitImage);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      AuthUseCase authUseCase = AuthUseCase(
          repository: AuthRepositoryImpl(
              apiService: AuthApiService(client: http.Client()), prefs: prefs));
      final token = await authUseCase.saveDetailscall(usersaveDetails);
      emit(AuthLoginEntryDataState());
    });

    // on<CheckLogin>((event, emit) async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   final token = prefs.getString('msg');

    //   if (token != null) {
    //     emit(AuthAuthenticated());
    //   } else {
    //     emit(AuthUnAuthenticated());
    //   }
    // });
  }
}
