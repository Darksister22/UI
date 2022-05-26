import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'http://127.0.0.1:8000';

  Future postData(Map data, String apiUrl) async {
    var fullUrl = _url + apiUrl;

    var headers = await _setHeaders();

    final res = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: headers);
    return res;
  }

  Future getAuth(String apiUrl) async {
    var fullUrl = _url + apiUrl;

    var headers = await _setHeaders();

    final res = await http.post(Uri.parse(fullUrl), headers: headers);
    print(res.statusCode);
    if (res.statusCode == 403)
      return 0;
    else
      return 1;
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    var headers = await _setHeaders();
    var response = await http.get(Uri.parse(fullUrl), headers: headers);
    return response;
  }

  Future<Map<String, String>> _setHeaders() async {
    final t = await _getToken();

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": 'Bearer ' + t,
    };
  }

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print(token);
    return '$token';
  }

  getArticles(apiUrl) async {}
  getPublicData(apiUrl) async {}
}
