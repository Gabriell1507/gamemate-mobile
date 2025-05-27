import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final void Function(String)? onChanged;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomInput({
    Key? key,
    required this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(0, 31, 63, 1),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(34, 132, 230, 1)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(34, 132, 230, 1)),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
