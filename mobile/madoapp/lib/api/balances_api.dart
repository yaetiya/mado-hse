import 'dart:convert';

import 'package:madoapp/configs/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:madoapp/models/user_balances.dart';

class BalancesApi {
  static Future<UserBalance> getBalance(String address) async {
    var url = ApiConfig.urlBuilder('balances', {'address': address});

    final response = await http.get(url);
    return UserBalance.fromJson(jsonDecode(response.body));
  }
}
