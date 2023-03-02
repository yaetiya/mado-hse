import 'package:flutter/cupertino.dart';
import 'package:madoapp/pages/HomePage/home_page.dart';
import 'package:madoapp/pages/NftFeedPage/nft_feed_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.film),
            // label: 'NFT feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_alt),
            // label: 'Home',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          routes: {
            '/': (context) => const MainPage(),
          },
          builder: (BuildContext context) {
            if (index == 0) {
              return const NftFeedPage();
            }
            if (index == 1) {
              return const HomePage();
            }
            return Center(
              child: Text('Content of tab $index'),
            );
          },
        );
      },
    );
  }
}
