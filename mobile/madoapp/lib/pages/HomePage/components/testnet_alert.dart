import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/blocs/network/network_bloc.dart';
import 'package:madoapp/blocs/network/network_event.dart';
import 'package:madoapp/configs/theme_config.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestnetAlert extends StatelessWidget {
  const TestnetAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0), color: ThemeConfig.kYellow),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: AppLocalizations.of(context)!.testnetAlert1,
                  style: const TextStyle(fontSize: 14)),
              TextSpan(
                  text: AppLocalizations.of(context)!.testnetAlert2,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      networkBloc.add(SwitchNetwork());
                    },
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ThemeConfig.kPrimary,
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
