import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthResources {
  static Future login({
    required String prefix,
    required Object body,
  }) async {
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return json.decode(response.body);
  }

  static Future signUp({
    required String prefix,
    required Object body,
  }) async {
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return json.decode(response.body);
  }

  static Future getUserDetail({
    required String prefix,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.get(
      Uri.parse('$baseUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  // Share Preferences
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }
}
