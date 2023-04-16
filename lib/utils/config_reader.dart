import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';

abstract class ConfigReader {
  static Map<String, dynamic> _config = new Map();
  static Singleton singleton = new Singleton();

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getServer() {
    return _config['server'] as String;
  }
}
