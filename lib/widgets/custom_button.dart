import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool enable;
  final int disabledOpacityPercent;
  final List<Color> color;
  final double radius;
  final VoidCallback onTap;
  final Widget? child;

  CustomButton({this.enable = true, this.disabledOpacityPercent = 40, required this.color, this.radius = 16.0, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    List<Color> disabledColor() {
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
    }
    // TODO: implement build
    return Container(
      height: 50.0,
      child: ElevatedButton(
        onPressed: enable ? onTap : () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          primary: Colors.white,
          padding: EdgeInsets.all(0.0),
        ),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: enable
                    ? color
                    : disabledColor(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(radius)),
          child: Container(
            constraints: BoxConstraints(maxWidth: double.infinity, minHeight: 50.0),
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
