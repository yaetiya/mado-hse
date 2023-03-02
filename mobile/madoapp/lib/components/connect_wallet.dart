import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_event.dart';
import 'package:madoapp/components/custom_divider.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/pages/CoursePage/components/active_course.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'big_button.dart';

class ConnectWallet extends StatefulWidget {
  const ConnectWallet({Key? key}) : super(key: key);

  @override
  State<ConnectWallet> createState() => _ConnectWalletState();
}

class _ConnectWalletState extends State<ConnectWallet> {
  // @override
  // void initState() {
  //   if (Platform.isAndroid) {
  //     throw Exception("No Android tw url");
  //   }
  //   super.initState();
  // }
  final String trustWalletDownloadUrl = Platform.isAndroid
      ? "https://play.google.com/store/apps/details?id=com.wallet.crypto.trustapp&referrer=utm_source%3Dwebsite"
      : "https://apps.apple.com/app/apple-store/id1288339409?mt=8";
  @override
  Widget build(BuildContext context) {
    double fullWidthWithoutPadding =
        MediaQuery.of(context).size.width - 2 * paddingX;
    return Wrap(
      spacing: 10,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.wcTitle,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.wcDescription,
        ),
        const SizedBox(
          height: 10,
        ),
        const CustomDivider(),
        const SizedBox(
          height: 70,
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            children: <TextSpan>[
              TextSpan(
                text: AppLocalizations.of(context)!.wcStep1,
              ),
              TextSpan(
                  text: AppLocalizations.of(context)!.wcStep1Link,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(trustWalletDownloadUrl, forceSafariVC: false);
                    },
                  style: const TextStyle(
                    color: ThemeConfig.kPrimary,
                  )),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.wcStep2,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        BigButton(
            width: fullWidthWithoutPadding,
            text: AppLocalizations.of(context)!.connectWallet,
            backgroundColor: ThemeConfig.kPrimary,
            textFontSize: 18,
            onPress: () {
              userBloc.add(TriggerWalletConnect());
              Navigator.pop(context);
            }),
        const SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.ifNothingHappens,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
