import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/api/nft_feed_api.dart';
import 'package:madoapp/blocs/nft_feed/nft_feed_bloc.dart';
import 'package:madoapp/blocs/nft_feed/nft_feed_event.dart';
import 'package:madoapp/blocs/nft_feed/nft_feed_state.dart';
import 'package:madoapp/components/bouncing.dart';
import 'package:madoapp/components/show_paper.dart';
import 'package:madoapp/components/wrap_indicator.dart';
import 'package:madoapp/configs/nft_feed_server_config.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/models/nft_feed_element.dart';
import 'package:madoapp/pages/HomePage/components/social_networks_popup_content.dart';

import 'components/nft_feed_element_widget.dart';

class NftFeedPage extends StatefulWidget {
  const NftFeedPage({Key? key}) : super(key: key);

  @override
  State<NftFeedPage> createState() => _NftFeedPageState();
}

class _NftFeedPageState extends State<NftFeedPage> {
  ScrollController _scrollController = ScrollController();
  List<NftFeedElement> _feedData = [];
  bool _loading = true, _isBlockFetch = false;
  void onScroll() {
    var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;
    if (!_isBlockFetch &&
        !_loading &&
        _scrollController.position.pixels > nextPageTrigger) {
      _loading = true;
      nftFeedBloc.add(GetNftFeed());
    }
  }

  void nftFeedBlocListener(NftFeedState event) {
    if (event is NftFeedLoaded) {
      _feedData = event.nftFeedElements;
      setState(() {});
    }
    if (event is NftFeedLoaded && (event.isBackup || event.isScrollEnd)) {
      _isBlockFetch = true;
    }
    if (event is NftFeedLoaded) {
      _loading = false;
      _isBlockFetch = false;
      setState(() {});
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onScroll);
    nftFeedBloc.stream.listen(nftFeedBlocListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(onScroll);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: _loading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Loading'),
                    SizedBox(
                      width: 10,
                    ),
                    CupertinoActivityIndicator()
                  ],
                )
              : const Text("NFT Feed"),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Bouncing(
                    onPress: () async {
                      ShowPaper.showActionSheet(
                          context, const SocialNetworksPopupContent());
                    },
                    child: AbsorbPointer(
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        child: const Text(
                          "🌅",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Bouncing(
                    onPress: () async {
                      // ShowPaper.showActionSheet(context,
                      //     ServiceView(url: 'https://linktr.ee/madoapp'),
                      //     isWithPadding: false);
                    },
                    child: AbsorbPointer(
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        child: const Text(
                          "  ",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            child: CupertinoScrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: WarpIndicator(
                skyColor: Colors.white,
                starColorGetter: (int a) => Colors.black,
                onRefresh: () async {
                  await NftFeedServerConfig.loadConfig();
                  final nftFeedElements = await NftFeedApi.fetchNftFeed(
                      0, NftFeedServerConfig.totalFeedCount);
                  nftFeedBloc.add(ResetNftFeed(nftFeedElements));
                },
                child: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(color: ThemeConfig.kBgGrey),
                  child: ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      // physics: NeverScrollableScrollPhysics(),
                      // scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      children: _feedData
                          .map((e) => NftFeedElementWidget(
                                nftFeedElement: e,
                              ))
                          .toList()),
                ),
              ),
            ),
          ),
        ));
  }
}
