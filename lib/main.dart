import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mota_engil_mobile/home.dart';
import 'package:mota_engil_mobile/login.dart';
import 'package:mota_engil_mobile/utils/api_service.dart';
import 'package:mota_engil_mobile/utils/config_reader.dart';
import 'package:mota_engil_mobile/utils/file_manager.dart';
import 'package:mota_engil_mobile/utils/security_service.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  await ConfigReader.initialize();
  String? initialRoute = 'login';

  Singleton singleton = new Singleton();
  singleton.clear();

  try {
    singleton.localDir = (await getApplicationDocumentsDirectory()).path;

    String? token = await getToken();

    /*final prefs = await SharedPreferences.getInstance();
    await prefs.setString('get_version', newVersion);*/

    /*List<Music> loads_format = [
      Music(id: 1, name: '1'),
      Music(id: 2, name: '2'),
      Music(id: 3, name: '3'),
    ];
    String encodedData = Music.encode(loads_format);
    final List<Music> musics = Music.decode(encodedData);*/

    if (token!.isNotEmpty) {
      singleton.id = (await getId())!;
      singleton.name = (await getName())!;

      initialRoute = 'home';
    } else {
      http.Response apiResponse =
          await ApiService.get('/auth/validate', secure: true);

      if (apiResponse.statusCode == 200) {
        var data = jsonDecode(apiResponse.body);
        if (data['msg'] == 'ok') {
          singleton.id = data["data"]["user"]["id"];
          singleton.name = data["data"]["user"]["name"];
          setToken(data["data"]["token"]);
          setName(data["data"]["user"]["name"]);

          initialRoute = 'home';
        }
      }
    }
  } catch (e) {}

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String? initialRoute;

  const MyApp({Key? key, @required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiPro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        'login': (context) => LoginScreen(),
        'home': (context) => HomeScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
// Unable to load asset: /data/user/0/com.poopaye.motaengil/app_flutter/map/12/2179/1261.png
//                       /data/user/0/com.poopaye.motaengil/app_flutter/map/14/8727/5045.png

class Music {
  final int? id;
  final String? name;

  Music({
    this.id,
    this.name,
  });

  factory Music.fromJson(Map<String, dynamic> jsonData) {
    return Music(
      id: jsonData['id'],
      name: jsonData['name'],
    );
  }

  static Map<String, dynamic> toMap(Music music) => {
        'id': music.id,
        'name': music.name,
      };

  static String encode(List<Music> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => Music.toMap(music))
            .toList(),
      );

  static List<Music> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Music>((item) => Music.fromJson(item))
          .toList();
}
