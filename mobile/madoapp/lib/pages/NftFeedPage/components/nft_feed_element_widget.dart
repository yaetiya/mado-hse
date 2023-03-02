import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:madoapp/api/nft_feed_api.dart';
import 'package:madoapp/components/bouncing.dart';
import 'package:madoapp/components/image_loader.dart';
import 'package:madoapp/components/video_loader.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/models/nft_feed_element.dart';
import 'package:madoapp/tools/colors_tools.dart';
import 'package:madoapp/tools/string_tools.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibration/vibration.dart';

class NftFeedElementWidget extends StatefulWidget {
  final NftFeedElement nftFeedElement;
  const NftFeedElementWidget({Key? key, required this.nftFeedElement})
      : super(key: key);

  @override
  State<NftFeedElementWidget> createState() => _NftFeedElementWidgetState();
}

class _NftFeedElementWidgetState extends State<NftFeedElementWidget> {
  void onLikeBtnClick(EmojiOnPost e) async {
    e.isWithMyLike = !e.isWithMyLike;
    e.count = e.count + (e.isWithMyLike ? 1 : -1);
    setState(() {});
    if (await Vibration.hasVibrator() ?? false) {
      if (await Vibration.hasAmplitudeControl() ?? false) {
        const power = 150, duration = 15;
        Vibration.vibrate(
            pattern: [10, duration, 10, 10], intensities: [1, power]);
      }
    }
    try {
      if (e.isWithMyLike) {
        e.count = (await NftFeedApi.addEmojiOnPost(
                widget.nftFeedElement.id, e.emoji.name))
            .count;
      } else {
        e.count = (await NftFeedApi.removeEmojiFromPost(
                widget.nftFeedElement.id, e.emoji.name))
            .count;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  if (widget.nftFeedElement.emojis.isNotEmpty) {
                    onLikeBtnClick(widget.nftFeedElement.emojis.first);
                  }
                },
                child: widget.nftFeedElement.mediaUrl.endsWith('mp4')
                    ? VideoLoader(
                        url: widget.nftFeedElement.mediaUrl,
                        imgSize: width - 6 - 10,
                        borderRadius: 14,
                      )
                    : ImageLoader(
                        url: widget.nftFeedElement.mediaUrl,
                        imgSize: width - 6 - 10,
                        borderRadius: 14,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(widget.nftFeedElement.postText,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left),
                    ),
                    Row(
                      children: widget.nftFeedElement.emojis
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Bouncing(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: e.isWithMyLike
                                                    ? e.emoji.textColor
                                                        .toColor()
                                                        ?.withOpacity(0.55)
                                                    : e.emoji.bgColor
                                                        .toColor()),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14.0,
                                                      vertical: 5),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 1),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                          text: e.emoji.symbol,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      20)),
                                                      const TextSpan(
                                                        text: '  ',
                                                      ),
                                                      WidgetSpan(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 1),
                                                        child: Text(
                                                          e.count.toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: e.isWithMyLike
                                                                ? Colors.white
                                                                : e.emoji
                                                                    .textColor
                                                                    .toColor(),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFeatures: const [
                                                              FontFeature
                                                                  .tabularFigures()
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                        onPress: () {
                                          onLikeBtnClick(e);
                                        }),
                                  ))
                              .toList() +
                          [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: widget.nftFeedElement.mediaUrl
                                      .endsWith('mp4')
                                  ? const SizedBox()
                                  : Bouncing(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: ThemeConfig.kBgGrey),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11, vertical: 9),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 2),
                                              child: Icon(
                                                CupertinoIcons.share,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                            ),
                                          )),
                                      onPress: () async {
                                        final cache = DefaultCacheManager();
                                        final file = await cache.getSingleFile(
                                            widget.nftFeedElement.mediaUrl);
                                        Share.shareFiles(
                                          [file.path],
                                          subject: widget
                                                  .nftFeedElement.postText +
                                              '🚀 Join https://t.me/madoapp',
                                        );
                                      }),
                            )
                          ],
                    ),
                    const SizedBox(
                      height: 4,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
