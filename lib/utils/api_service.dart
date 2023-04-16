import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mota_engil_mobile/utils/security_service.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';

import 'config_reader.dart';

class ApiService {
  static const int TIMEOUT = 10;
  Singleton singleton = new Singleton();

  static String getUrl(String url, {Map? queryParam}) {
    String finalUrl = '${ConfigReader.getServer()}' + url + '?';
    if (queryParam != null) {
      queryParam.entries.forEach((element) {
        finalUrl +=
            '&' + element.key.toString() + '=' + element.value.toString();
      });
    }
    return finalUrl;
  }

  static Future<http.Response> get(String url,
      {Map? queryParam, bool secure = false}) async {
    String finalUrl = '${ConfigReader.getServer()}' + url;
    if (queryParam != null) {
      finalUrl += '?';
      queryParam.entries.forEach((element) {
        finalUrl +=
            '&' + element.key.toString() + '=' + element.value.toString();
      });
    }

    String? token = '';
    if (secure) {
      token = await getToken();
    }

    http.Response response = await http
        .get(
      Uri.parse(finalUrl),
      headers: secure
          ? <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer ${token}'
            }
          : <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
    )
        .timeout(
      const Duration(seconds: TIMEOUT),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    );
    return response;
  }

  static Future<http.Response> post(String url, Map body,
      {Map? queryParam, bool secure = false}) async {
    String finalUrl = '${ConfigReader.getServer()}' + url;
    if (queryParam != null) {
      finalUrl += '?';
      queryParam.entries.forEach((element) {
        finalUrl +=
            '&' + element.key.toString() + '=' + element.value.toString();
      });
    }

    String? token = '';
    if (secure) {
      token = await getToken();
    }

    http.Response response = await http
        .post(
      Uri.parse(finalUrl),
      headers: secure
          ? <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer ${token}'
            }
          : <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
      body: jsonEncode(body),
    )
        .timeout(
      const Duration(seconds: TIMEOUT),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    );

    return response;
  }

/*static Future<ApiResponse> put(String url, Map body,
      {Map? queryParam}) async {
    HttpClient httpClient = _initRequest();
    String finalUrl = '${ConfigReader.getServer()}' + url + '?';
    if (queryParam != null) {
      queryParam.entries.forEach((element) {
        finalUrl +=
            '&' + element.key.toString() + '=' + element.value.toString();
      });
    }
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(finalUrl));
    request.headers.set('content-type', 'application/json');
    await _addAuthorization(request);
    request.add(utf8.encode(json.encode(body)));

    return await _parseRespone(httpClient, request);
  }

  static Future<ApiResponse> delete(String url,
      {Map? queryParam, Map? body}) async {
    HttpClient httpClient = _initRequest();
    String finalUrl = getUrl(url, queryParam: queryParam);
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(finalUrl));
    request.headers.set('content-type', 'application/json');
    await _addAuthorization(request);
    if (body != null) request.add(utf8.encode(json.encode(body)));
    return await _parseRespone(httpClient, request);
  }

  static Future putBinary(String url, File file) async {
    var response =
        await http.put(Uri.parse(url), body: await file.readAsBytesSync());

    return response;
  }*/
}
