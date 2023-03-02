import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_event.dart';
import 'package:madoapp/blocs/user/user_state.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/tools/string_tools.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class ServiceView extends StatefulWidget {
  final String url;
  ServiceView({Key? key, required this.url}) : super(key: key);

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  double loadingProgress = 0.0;
  void onLoadingWebview(int progress) {
    loadingProgress = progress / 100.0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = (Get.height * 0.9).toInt() - 23.0;
    return Wrap(
      children: [
        loadingProgress < 0.9
            ? LinearProgressIndicator(
                color: ThemeConfig.kPrimary,
                value: loadingProgress,
                minHeight: 4,
              )
            : Container(height: 4, color: Colors.transparent),
        SizedBox(
          height: height,
          child: WebView(
            backgroundColor: ThemeConfig.kLoadingGrey,
            initialCookies: (StringTools.isMadoUrl(widget.url))
                ? [
                    WebViewCookie(
                        name: 'access_token',
                        value: (userBloc.state as UserLoaded)
                            .userModel
                            .accessToken,
                        domain: 'mado.one')
                  ]
                : [],
            initialUrl: widget.url,
            gestureNavigationEnabled: true,
            onProgress: onLoadingWebview,
            javascriptChannels: {
              JavascriptChannel(
                  name: 'MessageInvoker',
                  onMessageReceived: (s) {
                    if (s.message == "event/unlocked") {
                      userBloc.add(GetUser());
                      Navigator.pop(context);
                    }
                  })
            },
            gestureRecognizers: {}
              ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
              ))
              ..add(Factory<HorizontalDragGestureRecognizer>(
                () => HorizontalDragGestureRecognizer(),
              )),
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ],
    );
  }
}
