import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mota_engil_mobile/widgets/custom_button.dart';

Widget CustomLoad(
    context, String name, bool isEnable, bool isLastItem, dynamic action) {
  return Container(
    padding: EdgeInsets.only(left: 16.0, right: 16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 32.0, 0, 16.0),
          child: Text(
            name,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
        ),
        CustomButton(
          color: [Color(0xFF006EB9), Color(0xFF006EB9)],
          radius: 8.0,
          enable: isEnable,
          onTap: action,
          child: const Center(
            child: Text(
              'Iniciar',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18.0),
            ),
          ),
        ),
        isLastItem
            ? Text('')
            : const Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                ),
                child: Divider(color: Colors.black),
              ),
      ],
    ),
  );
}
