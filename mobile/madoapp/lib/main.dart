import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/blocs/network/network_bloc.dart';
import 'package:madoapp/blocs/network/network_event.dart';
import 'package:madoapp/blocs/nft_feed/nft_feed_bloc.dart';
import 'package:madoapp/blocs/notifications_permission/notifications_permission_bloc.dart';
import 'package:madoapp/blocs/notifications_permission/notifications_permission_event.dart';
import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_event.dart';
import 'package:madoapp/models/runtime_config.dart';
import 'package:madoapp/pages/CoursePage/course_page.dart';
import 'package:madoapp/pages/HomePage/home_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:madoapp/pages/MainPage/main_page.dart';
import 'package:madoapp/services/load_local_content.dart';
import 'package:madoapp/services/payment_service.dart';
import 'package:madoapp/services/push_notification_service.dart';
import 'blocs/nft_feed/nft_feed_event.dart';
import 'blocs/user/user_state.dart';
import 'configs/nft_feed_server_config.dart';
import 'firebase_options.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future loadUser() async {
    userBloc.add(GetUser());
  }

  bool isFirstCallback = true;
  void onUserLoaded(UserState event) {
    if (event is! UserLoaded) return;
    if (isFirstCallback) {
      isFirstCallback = false;
      PaymentService.instance.initConnection();
      LoadLocalContent.init();
      PushNotificationService.init();
      nftFeedBloc.add(GetNftFeed());
    }
  }

  @override
  void initState() {
    super.initState();
    networkBloc.add(InitNetwork());
    NftFeedServerConfig.loadConfig().then((x) {
      notificationsPermissionBloc.add(InitNotificationsPermission());
      loadUser();
      userBloc.stream.listen(onUserLoaded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) {
        RuntimeConfig.region = AppLocalizations.of(context)!.localeName;
        return AppLocalizations.of(context)!.appTitle;
      },
      theme: const CupertinoThemeData(brightness: Brightness.light),
      initialRoute: '/',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        '/': (context) => const MainPage(),
        CoursePage.routeName: (context) => const CoursePage(),
      },
    );
  }
}
