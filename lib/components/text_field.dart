import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkingapp/utilities/constants.dart';

// ignore: must_be_immutable
class StyledTextField extends StatelessWidget {
  final bool isObscureText;
  final TextEditingController controller;
  final String labelText;
  final int maxLines;
  final IconData prefixIcon;

  StyledTextField({
    required this.isObscureText,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      style: TextStyle(color: kTealBasic),
      obscureText: isObscureText,
      controller: controller,
      cursorColor: kTealBasic,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 15.0, color: kTealBasic),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        prefixIcon: Icon(
          prefixIcon,
          color: kTealBasic,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
            color: kTealBasic,
            width: 1.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
            color: kTealBasic,
            width: 1.0,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
            color: kTealBasic,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
            color: kTealBasic,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
