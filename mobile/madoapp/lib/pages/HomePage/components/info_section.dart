import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/components/bouncing.dart';
import 'package:madoapp/components/show_paper.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/pages/HomePage/components/social_networks_popup_content.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoSection extends StatefulWidget {
  final String version, buildNumber;
  const InfoSection(
      {Key? key, required this.buildNumber, required this.version})
      : super(key: key);

  @override
  State<InfoSection> createState() => _InfoSectionState();
}

class _InfoSectionState extends State<InfoSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
      child: Column(
        children: [
          InfoSectionItem(
            onClick: () {
              ShowPaper.showActionSheet(
                  context, const SocialNetworksPopupContent());
            },
            title: AppLocalizations.of(context)!.socialNetworksTitle,
            subtitle: AppLocalizations.of(context)!.socialNetworksDescription,
          ),
          SizedBox(
            height: 50,
          ),
          InfoSectionItem(
            onClick: () {},
            title: AppLocalizations.of(context)!.aboutTheAppTitle,
            subtitle: "Version ${widget.version} (${widget.buildNumber}) Alpha",
          ),
        ],
      ),
    );
  }
}

class InfoSectionItem extends StatelessWidget {
  final void Function() onClick;
  final String title, subtitle;
  const InfoSectionItem(
      {Key? key,
      required this.subtitle,
      required this.onClick,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bouncing(
        onPress: onClick,
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey),
              )
            ],
          ),
        ));
  }
}
