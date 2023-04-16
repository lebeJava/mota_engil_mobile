import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mota_engil_mobile/home.dart';
import 'package:mota_engil_mobile/loads_detail.dart';
import 'package:mota_engil_mobile/utils/api_service.dart';
import 'package:mota_engil_mobile/utils/security_service.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';
import 'package:mota_engil_mobile/widgets/custom_button.dart';
import 'package:mota_engil_mobile/widgets/custom_input.dart';
import 'package:mota_engil_mobile/widgets/custom_load.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoadsScreen();
  }
}

class _LoadsScreen extends State<LoadsScreen> {
  var singleton = Singleton();
  bool loading = false;

  final TextInputType text = TextInputType.text;

  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return loadsUI();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget loadsUI() {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF006EB9),
        title: Text(
          'Selecciona una opción',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListView.builder(
              itemCount: singleton.loads.length,
              itemBuilder: (BuildContext context, int index) => Align(
                alignment: Alignment.center,
                child: CustomLoad(
                  context,
                  singleton.loads[index]['name'],
                  singleton.loads[index]['isEnable'],
                  (index == singleton.loads.length - 1),
                  () {
                    singleton.loadSelectedIndex = index;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoadsDetailScreen()));
                  },
                ),
              ),
            ),
          ),
          loading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0x46000000),
                )
              : Text('')
        ],
      ),
    );
  }
}
