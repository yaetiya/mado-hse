import 'package:madoapp/configs/api_config.dart';
import 'package:madoapp/models/social_network.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CmsApi {
  static Future<List<SocialNetwork>> getSocialMedias() async {
    var url = ApiConfig.urlBuilder('cms/social-networks/get');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> socialNetworksMap = jsonDecode(response.body);
      return socialNetworksMap.map((e) => SocialNetwork.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load social networks");
    }
  }
}
