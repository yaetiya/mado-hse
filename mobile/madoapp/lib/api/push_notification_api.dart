import 'dart:convert';

import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_state.dart';
import 'package:madoapp/configs/api_config.dart';
import 'package:http/http.dart' as http;

class PushNotificationApi {
  static Future<bool> sendToken(String token) async {
    var url = ApiConfig.urlBuilder('notifications/add-token');

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${(userBloc.state as UserLoaded).userModel.accessToken}',
        },
        body: jsonEncode({
          'token': token,
        }));
    return response.statusCode == 200;
  }
}
