import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,

     this.obscureText=false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon,color: Colors.black,),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.blueGrey,fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
      ),
      cursorColor: Colors.white70,
    );
  }
}
