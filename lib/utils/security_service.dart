import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const KEY_TOKEN = 'token';
const KEY_ID = 'id';
const KEY_NAME = 'name';

Future<void> setToken(String? token) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: KEY_TOKEN, value: token);
}

Future<String?> getToken() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: KEY_TOKEN);
  return token;
}

Future<void> removeToken() async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: KEY_TOKEN);
}

Future<void> setId(String? id) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: KEY_ID, value: id);
}

Future<String?> getId() async {
  const storage = FlutterSecureStorage();
  String? id = await storage.read(key: KEY_ID);
  return id;
}

Future<void> removeId() async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: KEY_ID);
}

Future<void> setName(String? name) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: KEY_NAME, value: name);
}

Future<String?> getName() async {
  const storage = FlutterSecureStorage();
  String? name = await storage.read(key: KEY_NAME);
  return name;
}

Future<void> removeName() async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: KEY_NAME);
}
