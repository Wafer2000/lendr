import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextField(
      {super.key,
      required this.labelText,
      required this.obscureText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            )),
      ),
      obscureText: obscureText,
    );
  }
}
