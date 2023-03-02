import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/pages/CoursePage/components/active_course.dart';
import 'package:url_launcher/url_launcher.dart';

import 'big_button.dart';
import 'custom_divider.dart';

class ConnectWalletError extends StatelessWidget {
  const ConnectWalletError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullWidthWithoutPadding =
        MediaQuery.of(context).size.width - 2 * paddingX;
    return Wrap(
      spacing: 10,
      children: <Widget>[
        Text(
          "Wallet connecting error",
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(
          height: 100,
        ),
        // Text(
        //   "Todo: тут будет текст, что можно попробовать другие аппы с ссылками на них",
        //   style: const TextStyle(
        //       fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        // ),
        BigButton(
            width: fullWidthWithoutPadding,
            text: "Ok",
            backgroundColor: ThemeConfig.kPrimary,
            textFontSize: 18,
            onPress: () {
              Navigator.pop(context);
            }),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
