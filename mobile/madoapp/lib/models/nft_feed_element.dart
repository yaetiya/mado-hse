import 'dart:convert';

import 'package:madoapp/configs/nft_feed_server_config.dart';

import 'emoji.dart';

class NftFeedElement {
  late String id;
  late String mediaUrl;
  late String postText;
  late String contractAddress;
  late String tokenId;
  late String price;
  late List<EmojiOnPost> emojis;
  NftFeedElement(this.id, this.mediaUrl, this.postText, this.contractAddress,
      this.tokenId, this.price, this.emojis);

  NftFeedElement.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    emojis = ((((json['emojis']) ?? []) as List)
        .map((x) {
          if (!EmojiOnPost.validateTypes(x)) return null;
          return EmojiOnPost.fromJson(x);
        })
        .where((element) => (element != null))
        .map((e) => e as EmojiOnPost)).toList();
    mediaUrl = json['mediaUrl'];
    postText = json['postText'];
    contractAddress = json['contractAddress'];
    tokenId = json['tokenId'];
    price = json['price'];
  }
  toJson() {
    return {
      '_id': id,
      'emojis': emojis.map((e) => e.toJson()).toList(),
      'mediaUrl': mediaUrl,
      'contractAddress': contractAddress,
      'tokenId': tokenId,
      'price': price,
      'postText': postText
    };
  }
}

class EmojiOnPost {
  late Emoji emoji;
  late int count;
  late bool isWithMyLike;
  EmojiOnPost(this.emoji, this.count, this.isWithMyLike);
  EmojiOnPost.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    isWithMyLike = json['isWithMyLike'];
    emoji = NftFeedServerConfig.supportedEmojis
        .firstWhere((element) => element.name == json['emoji']);
  }
  static validateTypes(Map<String, dynamic> json) {
    return NftFeedServerConfig.supportedEmojis
        .any((element) => element.name == json['emoji']);
  }

  toJson() {
    return {
      'emoji': emoji.name,
      'count': count,
      'isWithMyLike': isWithMyLike,
    };
  }
}
