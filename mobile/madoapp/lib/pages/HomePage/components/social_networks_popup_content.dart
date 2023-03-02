import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/api/cms_api.dart';
import 'package:madoapp/components/bouncing.dart';
import 'package:madoapp/components/image_loader.dart';
import 'package:madoapp/models/social_network.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SocialNetworksPopupContent extends StatelessWidget {
  const SocialNetworksPopupContent({Key? key}) : super(key: key);
  Future<List<SocialNetwork>> loadSocialMedias() async {
    return await CmsApi.getSocialMedias();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadSocialMedias(),
        builder: (context, AsyncSnapshot<List<SocialNetwork>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text('Error. Check your internat connection'));
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return Column(
            children:  [
                  Text(
                      AppLocalizations.of(context)!.socialNetworksPageTitle + ' 😎',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  const SizedBox(
                    height: 70,
                  ),
                ] +
                snapshot.data!
                    .map((e) => SocialNetworkItem(
                          socialNetwork: e,
                        ))
                    .toList(),
          );
        });
  }
}

class SocialNetworkItem extends StatelessWidget {
  final SocialNetwork socialNetwork;

  const SocialNetworkItem({
    Key? key,
    required this.socialNetwork,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Bouncing(
          onPress: () {
            launch(socialNetwork.url, forceSafariVC: false);
          },
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageLoader(url: socialNetwork.iconPath, imgSize: 30),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  socialNetwork.title,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          )),
    );
  }
}
