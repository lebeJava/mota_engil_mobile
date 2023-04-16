import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mota_engil_mobile/home.dart';
import 'package:mota_engil_mobile/utils/api_service.dart';
import 'package:mota_engil_mobile/utils/security_service.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';
import 'package:mota_engil_mobile/widgets/custom_button.dart';
import 'package:mota_engil_mobile/widgets/custom_input.dart';
import 'package:mota_engil_mobile/widgets/custom_load_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadsDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoadsDetailScreen();
  }
}

class _LoadsDetailScreen extends State<LoadsDetailScreen> {
  var singleton = new Singleton();
  bool loading = false;

  String material = 'Seleccionar >';

  bool btn1 = true, btn2 = true, btn3 = true;

  final textController = TextEditingController();
  final TextInputType text = TextInputType.text;

  late List options;
  List<String>? materials;
  String timestamp = '';
  int timestampUnix = 0;

  late int optionsIndex;

  late Timer _timer;

  init() async {
    int selectedLoad = singleton.loads[singleton.loadSelectedIndex]['id'];
    for (int i = 0; i < singleton.loadsOptions.length; i++) {
      if (singleton.loadsOptions[i]["loadId"] == selectedLoad) {
        optionsIndex = i;
        options = singleton.loadsOptions[i]["options"];
        break;
      }
    }

    final prefs = await SharedPreferences.getInstance();

    materials = prefs.getStringList('material');

    _getTime();

    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = DateFormat('hh:mm:ss').format(now);
    try {
      setState(() {
        timestamp = formattedDateTime;
        timestampUnix = now.millisecondsSinceEpoch;
      });
    } catch (e) {}
  }

  checkOptionsDone(optionsIndex) async {
    bool isEverythingMarked = true;
    for (int i = 0;
        i < singleton.loadsOptions[optionsIndex]["options"].length;
        i++) {
      if (singleton.loadsOptions[optionsIndex]["options"][i]['value']
          .toString()
          .isEmpty) {
        isEverythingMarked = false;
        break;
      }
    }

    if (isEverythingMarked) {
      singleton.loads[singleton.loadSelectedIndex]['isEnable'] = false;

      await delay(1);

      bool isNewTrip = true;
      for (int i = 0; i < singleton.loads.length; i++) {
        if (singleton.loads[i]['isEnable'] == true) {
          isNewTrip = false;
          break;
        }
      }

      if (isNewTrip) {
        singleton.trips = singleton.trips + 1;

        singleton.loads = new List.from(singleton.loadsOriginal);
        singleton.loadsOptions = new List.from(singleton.loadsOptionsOriginal);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadsUI();
  }

  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget loadsUI() {
    return WillPopScope(
      onWillPop: () {
        _timer.cancel();

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: Color(0xFF006EB9),
          title: Text(
            singleton.loads[singleton.loadSelectedIndex]['name'],
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) => Align(
                  alignment: Alignment.center,
                  child: CustomLoadOption(
                      context,
                      optionsIndex,
                      index,
                      options[index]["name"],
                      options[index]["type"],
                      options[index]["value"],
                      timestamp,
                      materials,
                      textController,
                      text,
                      (options[index]["value"].toString().isEmpty),
                      (index == options.length - 1),
                      checkOptionsDone),
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
      ),
    );
  }
}

delay(time) {
  return Future.delayed(Duration(seconds: time), () {});
}
