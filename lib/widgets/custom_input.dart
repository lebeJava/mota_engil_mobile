import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String? text;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool dark;
  final bool obscureText;
  final bool error;
  final String errorMsg;
  final TextAlign textAlign;
  final double fontSize;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final String placeholder;

  /*final bool enable;
  final int disabledOpacityPercent;
  final List<Color> color;
  final double radius;
  final VoidCallback onTap;
  final Widget? child;*/

  //CustomInput({this.enable = true, this.disabledOpacityPercent = 40, required this.color, this.radius = 16.0, required this.onTap, required this.child});
  CustomInput({
    this.text,
    required this.controller,
    required this.textInputType,
    this.dark = true,
    this.obscureText = false,
    this.error = false,
    this.errorMsg = '',
    this.textAlign = TextAlign.start,
    this.fontSize = 18.0,
    this.readOnly = false,
    this.enableInteractiveSelection = true,
    this.placeholder = '',
  });

  @override
  Widget build(BuildContext context) {
    /*List<Color> disabledColor() {
      List<Color> newColors = [];
      color.forEach((element) {
        String hexColor = element.value.toRadixString(16).toString().toUpperCase().replaceAll("#", "");

        // Calculate opacity percentage in hexadecimal.
        const double slope = 255 / 100;
        double output = (slope * (disabledOpacityPercent));
        int percentaje = output.round();

        if (hexColor.length == 6) {
          hexColor = percentaje.toRadixString(16).toString() + hexColor;
        }else if (hexColor.length == 8) {
          hexColor = hexColor.substring(2, 8);
          hexColor = percentaje.toRadixString(16).toString() + hexColor;
        }

        Color? newColor = Color(int.parse(hexColor, radix: 16));

        newColors.add(newColor);
      });
      return newColors;
    }*/
    // TODO: implement build
    return TextField(
      obscureText: obscureText,
      controller: controller,
      keyboardType: textInputType,
      textAlign: textAlign,
      readOnly: readOnly,
      enableInteractiveSelection: enableInteractiveSelection,
      style: TextStyle(
          fontSize: fontSize, color: dark ? Colors.black : Colors.white),
      decoration: InputDecoration(
        filled: true,
        hintText: placeholder,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: dark ? Color(0xFF006EB9) : Colors.white, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: dark ? Color(0xFF006EB9) : Colors.white, width: 1.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        labelText: text,
        labelStyle: TextStyle(fontSize: 18.0, color: Color(0xFF006EB9)),
        contentPadding: EdgeInsets.all(16),
        errorText: error ? errorMsg : null,
      ),
    );
  }
}
