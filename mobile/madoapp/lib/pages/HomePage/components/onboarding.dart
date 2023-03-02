import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:madoapp/blocs/notifications_permission/notifications_permission_bloc.dart';
import 'package:madoapp/blocs/notifications_permission/notifications_permission_event.dart';
import 'package:madoapp/components/big_button.dart';
import 'package:madoapp/configs/content_config.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:madoapp/pages/CoursePage/components/active_course.dart';
import 'package:madoapp/pages/CoursePage/course_page.dart';
import 'package:madoapp/routes/models.dart';
import 'package:madoapp/services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<String> descriptions(BuildContext context) => [
        AppLocalizations.of(context)!.onboardingDescription,
        AppLocalizations.of(context)!
            .onboardingDescription2
            .replaceAll('\\n', '\n'),
        AppLocalizations.of(context)!.onboardingDescription3
      ];
  late int activeStep = 0;

  void onOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is-onboarding-done-2', true);
  }

  @override
  Widget build(BuildContext context) {
    double fullWidthWithoutPadding =
        MediaQuery.of(context).size.width - 2 * paddingX;
    final isLastStep = activeStep == descriptions(context).length - 1;
    double logoWidth = fullWidthWithoutPadding * 0.7;
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 1,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 100, left: 40),
            child: SvgPicture.asset(
              'images/logo.svg',
              width: logoWidth,
            )),
        const SizedBox(
          height: 250,
        ),
        if (activeStep == 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(AppLocalizations.of(context)!.onboardingTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Text(descriptions(context)[activeStep],
              textAlign: activeStep == 1 ? TextAlign.start : TextAlign.center,
              style: TextStyle(
                  fontSize: isLastStep ? 18 : 15, color: Colors.black)),
        ),
        if (isLastStep)
          BigButton(
              width: fullWidthWithoutPadding,
              text: AppLocalizations.of(context)!.allowNotifications,
              backgroundColor: ThemeConfig.kPrimary,
              textFontSize: 18,
              onPress: () async {
                PushNotificationService.requestNotifications().then((_) {
                  notificationsPermissionBloc
                      .add(UpdateNotificationsPermission());
                });
                Navigator.of(context, rootNavigator: true).popAndPushNamed(
                  CoursePage.routeName,
                  arguments: ScreenArguments(
                    ContentConfig.getOnboardingCourseUid(),
                  ),
                );
                onOnboardingCompleted();
              }),
        const SizedBox(
          height: 70,
        ),
        BigButton(
            width: fullWidthWithoutPadding,
            text: isLastStep
                ? AppLocalizations.of(context)!.onboardingSkipBtn
                : AppLocalizations.of(context)!.onboardingBtnNext,
            backgroundColor:
                isLastStep ? ThemeConfig.kBtnGrey : ThemeConfig.kPrimary,
            textFontSize: 18,
            onPress: () {
              if (isLastStep) {
                Navigator.of(context, rootNavigator: true).popAndPushNamed(
                  CoursePage.routeName,
                  arguments: ScreenArguments(
                    ContentConfig.getOnboardingCourseUid(),
                  ),
                );
                onOnboardingCompleted();
              } else {
                setState(() {
                  activeStep++;
                });
              }
            }),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
