import 'package:madoapp/api/nft_feed_api.dart';
import 'package:madoapp/models/emoji.dart';

class NftFeedServerConfig {
  static late int totalFeedCount;
  static late List<Emoji> supportedEmojis = [
    Emoji('#FF8A00', '🔥', '#FFEEDA', 'fire'),
    Emoji('#EA4C4C', '❤️', '#FFE1E1', 'like')
  ];
  static Future<void> loadConfig() async {
    try {
      final configMap = await NftFeedApi.fetchFeedConfig();
      totalFeedCount = configMap["collectionTotalCount"];
      supportedEmojis =
          (configMap["emoji"] as List).map((x) => Emoji.fromJson(x)).toList();
    } catch (e) {}
  }
}
