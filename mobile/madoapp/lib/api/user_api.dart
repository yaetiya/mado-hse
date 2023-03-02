import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:madoapp/configs/api_config.dart';
import 'package:madoapp/models/runtime_config.dart';
import 'package:madoapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  static Future<User> createUser() async {
    var url = ApiConfig.urlBuilder('sign-up');

    final response =
        await http.post(url, headers: {'platform': RuntimeConfig.platform});
    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      final accessToken = userMap["token"]["accessToken"];
      userMap = userMap['user'];
      userMap["accessToken"] = accessToken;
      return User.fromJson(userMap);
    } else {
      throw Exception("Failed to create the user");
    }
  }

  static Future<User> getUserByJWT(String accessToken) async {
    var url = ApiConfig.urlBuilder('me');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken',
      'locale': RuntimeConfig.region
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      userMap["accessToken"] = accessToken;
      return User.fromJson(userMap);
    } else {
      throw Exception("Failed");
    }
  }

  static Future<bool> addAddress(String address, String accessToken) async {
    var url = ApiConfig.urlBuilder('add-address');

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"address": address}));

    return response.statusCode == 200;
  }

  static Future<User?> getUserLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr == null) return null;
    final userMap = jsonDecode(userStr);
    return User.fromJson(userMap);
  }

  static Future<void> saveUserLocally(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }
}
