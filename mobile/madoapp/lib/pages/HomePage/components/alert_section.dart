import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/blocs/notifications_permission/notifications_permission_bloc.dart';
import 'package:madoapp/blocs/notifications_permission/notifications_permission_event.dart';
import 'package:madoapp/components/bouncing.dart';
import 'package:madoapp/components/show_paper.dart';
import 'package:madoapp/components/subs_alert.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:madoapp/services/push_notification_service.dart';
import 'package:madoapp/services/scren_size_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AlertSection extends StatefulWidget {
  final bool isNotificationsAllowed;
  const AlertSection({Key? key, required this.isNotificationsAllowed})
      : super(key: key);

  @override
  State<AlertSection> createState() => _AlertSectionState();
}

class _AlertSectionState extends State<AlertSection> {
  @override
  Widget build(BuildContext context) {
    final isBigScreen = ScreenSizeService.isBigScreen(context);

    final widthWithoutPadding = (MediaQuery.of(context).size.width - 16 * 2);
    final textSectionWidth = widthWithoutPadding * 2 / 3;
    final imageSize = isBigScreen ? 40.0 : widthWithoutPadding * 1 / 3 / 2;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: ThemeConfig.kLoadingGrey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            direction: Axis.vertical,
            spacing: 20,
            children: [
              SizedBox(
                width: textSectionWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.infoAlertText,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // Bouncing(
                  //     child: Container(
                  //       color: Colors.white,
                  //       padding: const EdgeInsets.symmetric(vertical: 10),
                  //       child: Text(
                  //         AppLocalizations.of(context)!.subscribe,
                  //         style: const TextStyle(
                  //             color: ThemeConfig.kPrimary,
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.w500),
                  //       ),
                  //     ),
                  //     onPress: () {
                  //       ShowPaper.showActionSheet(context, const SubsAlert());
                  //     }),
                  // const SizedBox(
                  //   width: 25,
                  // ),
                  if (!widget.isNotificationsAllowed)
                    Bouncing(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppLocalizations.of(context)!.allowNotifications,
                            style: const TextStyle(
                                color: ThemeConfig.kPrimary, //Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        onPress: () async {
                          await PushNotificationService.requestNotifications();
                          notificationsPermissionBloc
                              .add(UpdateNotificationsPermission());
                        })
                ],
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 1, right: 8, top: 8, bottom: 18),
            child: Image.asset(
              'images/bell.png',
              width: imageSize,
            ),
          )
        ],
      ),
    );
  }
}
