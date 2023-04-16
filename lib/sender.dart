import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mota_engil_mobile/home.dart';
import 'package:mota_engil_mobile/loads_detail.dart';
import 'package:mota_engil_mobile/utils/api_service.dart';
import 'package:mota_engil_mobile/utils/config_reader.dart';
import 'package:mota_engil_mobile/utils/security_service.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';
import 'package:mota_engil_mobile/widgets/custom_button.dart';
import 'package:mota_engil_mobile/widgets/custom_input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SenderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SenderScreen();
  }
}

class _SenderScreen extends State<SenderScreen> {
  var singleton = Singleton();
  bool loading = false;

  Random random = new Random();

  String latestDate = '-';

  String currentVersion =
      DateFormat('yyyy-MM-dd–kk:mm:ss').format(DateTime.now());

  bool _downloading = false;
  String? _dir;
  List<String>? _images = [];
  String _zipPath = '${ConfigReader.getServer()}/map.zip';
  String _localZipFileName = 'images.zip';

  _initDir() async {
    if (null == _dir) {
      _dir = (await getApplicationDocumentsDirectory()).path;
      print("init $_dir");
    }
  }

  Future<File> _downloadFile(String url, String fileName) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$_dir/$fileName');
    print("file.path ${file.path}");
    return file.writeAsBytes(req.bodyBytes);
  }

  Future<void> update() async {
    setState(() {
      loading = true;
    });

    EasyLoading.show(
      status: 'Enviando...',
    );

    int randomValue = random.nextInt(4) + 1;

    await delay(randomValue);

    EasyLoading.dismiss();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('set_version', currentVersion);

    setState(() {
      loading = false;
      latestDate = currentVersion;
    });
  }

  loadLastestVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final String? version = prefs.getString('set_version');
    if (version!.isNotEmpty) {
      setState(() {
        latestDate = version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return senderUI();
  }

  @override
  void initState() {
    super.initState();
    _images = [];
    _downloading = false;
    _initDir();
    loadLastestVersion();
  }

  Widget senderUI() {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF006EB9),
        title: Text(
          'Enviar datos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      color: Color(0xFFFAFAFA),
                      child: Text(
                        'Versión actual:\n$currentVersion',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            'Última fecha de envío: ',
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            latestDate,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CustomButton(
                        color: [Color(0xFF006EB9), Color(0xFF006EB9)],
                        radius: 8.0,
                        onTap: () async {
                          await update();
                        },
                        child: Center(
                          child: Text(
                            'Enviar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFFFFFFFF), fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Divider(color: Colors.black),
                    ),
                  ],
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

delay(time) {
  return Future.delayed(Duration(seconds: time), () {});
}
