
import 'package:drive_driver_bloc/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Pendingscreen extends StatefulWidget {
 const  Pendingscreen({super.key});

  @override
  State<Pendingscreen> createState() => _PendingscreenState();
}




class _PendingscreenState extends State<Pendingscreen> {

@override
 
  
  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(
          'Pending Approval',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.black,
      ),
      body: Center(
        child: Container(
         
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey200.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitPouringHourGlass(color: AppColors.green,size: 70,),
              const SizedBox(height: 20),
              Text(
                'Waiting for approval',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
             const SizedBox(height: 10),
              Text(
                'Your request is being processed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
