import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/components/big_button.dart';
import 'package:madoapp/components/html_render.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/models/runtime_config.dart';
import 'package:madoapp/pages/CoursePage/components/active_course.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:madoapp/services/load_local_content.dart';

class SubsAlert extends StatefulWidget {
  const SubsAlert({Key? key}) : super(key: key);

  @override
  State<SubsAlert> createState() => _SubsAlertState();
}

class _SubsAlertState extends State<SubsAlert> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 400;
    double fullWidthWithoutPadding = width - 2 * paddingX;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: [
        Container(
          width: 130,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: ThemeConfig.kPrimary),
          child: const Center(
            child: Text(
              "Coming Soon",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 20),
            child: Text(AppLocalizations.of(context)!.subsTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 24 : 32,
                  fontWeight: FontWeight.w500,
                ))),
        SizedBox(height: isSmallScreen ? 5 : 20),
        HtmlRender(
            html: LoadLocalContent.getSubsDescription(RuntimeConfig.region)),
        SizedBox(height: isSmallScreen ? 5 : 20),
        BigButton(
            width: fullWidthWithoutPadding,
            text: AppLocalizations.of(context)!.subsSubscribeBtnText,
            backgroundColor: ThemeConfig.kPrimary.withOpacity(0.5),
            onPress: () {}),
        const SizedBox(
          height: 10,
        ),
        BigButton(
            width: fullWidthWithoutPadding,
            text: AppLocalizations.of(context)!.subsBuyBtnText,
            backgroundColor: Colors.black.withOpacity(0.5),
            onPress: () {})
      ],
    );
  }
}
