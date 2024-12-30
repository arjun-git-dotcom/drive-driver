import 'package:drive_driver_bloc/core/utils/colors.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:drive_driver_bloc/features/auth/presentation/bloc/auth_state.dart';
import 'package:drive_driver_bloc/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TextEditingController emailController = TextEditingController();

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF000000), Color(0xFF0F332C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App title
                      const Hero(
                        tag: 'appTitle',
                        child: Text(
                          'Driver App',
                          style: TextStyle(
                            fontFamily: 'DancingScript',
                            letterSpacing: 1.5,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Input fields in cards
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 8,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TextFieldWidget(
                              controller: nameController,
                              hint: 'Enter your name',
                              icon: Icons.person,
                             
                            ),
                            const SizedBox(height: 16),
                            TextFieldWidget(
                              controller: emailController,
                              hint: 'Enter your email',
                              icon: Icons.email,
                              
                            ),
                            const SizedBox(height: 16),
                            TextFieldWidget(
                              controller: passwordController,
                              hint: 'Enter your password',
                              icon: Icons.lock,
                              obscureText: true,
                            
                            ),
                            const SizedBox(height: 16),
                            TextFieldWidget(
                              controller: phoneNoController,
                              hint: 'Enter your phone number',
                              icon: Icons.phone,
                             
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Sign Up button
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.82,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(AuthReqtoLogin(
                              username: nameController.text.trim(),
                              password: passwordController.text.trim(),
                              email: emailController.text.trim(),
                              phoneNumber: phoneNoController.text.trim(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.greenAccent,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(0),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2AD789), Color(0xFF11998E)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Login link
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context).add(AuthPending());
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text('Login',style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
