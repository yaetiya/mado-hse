import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_state.dart';

import 'package:madoapp/configs/api_config.dart';
import 'package:madoapp/models/nft_feed_element.dart';
import 'package:madoapp/models/runtime_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NftFeedApi {
  static Future<List<NftFeedElement>> fetchNftFeed(
      int page, int totalCount) async {
    var url = ApiConfig.urlBuilder('feed/get', {
      "page": page.toString(),
      "collectionTotalCount": totalCount.toString()
    });

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${(userBloc.state as UserLoaded).userModel.accessToken}',
        'locale': RuntimeConfig.region
      },
    );
    final nftFeedMap = jsonDecode(response.body);
    return (nftFeedMap as List).map((e) => NftFeedElement.fromJson(e)).toList();
  }

  static Future<EmojiOnPost> addEmojiOnPost(
      String postId, String emojiName) async {
    var url = ApiConfig.urlBuilder('feed/emoji');

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${(userBloc.state as UserLoaded).userModel.accessToken}',
          'locale': RuntimeConfig.region
        },
        body: jsonEncode({'postId': postId, 'emoji': emojiName}));

    final emojiMap = jsonDecode(response.body);
    return EmojiOnPost.fromJson(emojiMap);
  }

  static Future<EmojiOnPost> removeEmojiFromPost(
      String postId, String emojiName) async {
    var url = ApiConfig.urlBuilder('feed/emoji');

    final response = await http.delete(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${(userBloc.state as UserLoaded).userModel.accessToken}',
          'locale': RuntimeConfig.region
        },
        body: jsonEncode({'postId': postId, 'emoji': emojiName}));

    final emojiMap = jsonDecode(response.body);
    return EmojiOnPost.fromJson(emojiMap);
  }

  static Future<Map<String, dynamic>> fetchFeedConfig() async {
    var url = ApiConfig.urlBuilder('feed/getConfig');
    final response = await http.get(url);
    final nftFeedConfigMap = jsonDecode(response.body);
    return nftFeedConfigMap;
  }

  static Future<List<NftFeedElement>?> getNftFeedLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final nftFeedStr = prefs.getString('nft-feed');
    if (nftFeedStr == null) return null;
    final nftFeedMap = jsonDecode(nftFeedStr);
    return (nftFeedMap as List).map((e) => NftFeedElement.fromJson(e)).toList();
  }

  static Future<void> saveNftFeedLocally(List<NftFeedElement> nftFeed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'nft-feed', jsonEncode(nftFeed.map((x) => x.toJson()).toList()));
  }
}
