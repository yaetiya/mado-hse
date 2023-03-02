// ignore_for_file: deprecated_member_use

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:madoapp/configs/html_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

const copyBase = 'copyaction.com';

class HtmlRender extends StatelessWidget {
  final String html;
  const HtmlRender({Key? key, required this.html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: HtmlConfig.styleConfig,
      customImageRenders: {
        networkSourceMatcher(): networkImageRender(
          loadingWidget: () => const Text(""),
        ),
      },
      onImageError: (obj, stack) {
        debugPrint('err');
      },
      onLinkTap: (url, ctx, attributes, element) async {
        if (url == null) {
          return;
        }
        if (url.contains(copyBase)) {
          Clipboard.setData(ClipboardData(text: element!.text));

          ElegantNotification.success(
                  toastDuration: const Duration(milliseconds: 800),
                  animation: AnimationType.fromTop,
                  displayCloseButton: false,
                  dismissible: false,
                  showProgressIndicator: false,
                  title: const Text("Copied"),
                  description: Text(element.text + ' copied to the clipboard'))
              .show(context);
          return;
        }
        if (await canLaunch(url)) {
          await launch(url, forceSafariVC: false);
        }
      },
    );
  }
}
