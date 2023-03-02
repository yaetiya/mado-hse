import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madoapp/api/projects_api.dart';
import 'package:madoapp/blocs/balance/balance_bloc.dart';
import 'package:madoapp/blocs/balance/balance_event.dart';
import 'package:madoapp/blocs/network/network_bloc.dart';
import 'package:madoapp/blocs/network/network_state.dart';
import 'package:madoapp/blocs/notifications_permission/notifications_permission_bloc.dart';
import 'package:madoapp/blocs/notifications_permission/notifications_permission_state.dart';
import 'package:madoapp/blocs/user/user_bloc.dart';
import 'package:madoapp/blocs/user/user_state.dart';
import 'package:madoapp/components/big_button.dart';
import 'package:madoapp/components/bouncing.dart';
import 'package:madoapp/components/connect_wallet.dart';
import 'package:madoapp/components/connect_wallet_error.dart';
import 'package:madoapp/components/html_render.dart';
import 'package:madoapp/components/service_view.dart';
import 'package:madoapp/components/show_paper.dart';
import 'package:madoapp/configs/content_config.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/models/project.dart';
import 'package:madoapp/models/runtime_config.dart';
import 'package:madoapp/pages/CoursePage/components/active_course.dart';
import 'package:madoapp/pages/HomePage/api/homepage_snapshot.dart';
import 'package:madoapp/pages/HomePage/components/alert_section.dart';
import 'package:madoapp/pages/HomePage/components/all_courses.dart';
import 'package:madoapp/pages/HomePage/components/onboarding.dart';
import 'package:madoapp/pages/HomePage/components/top_services.dart';

import 'package:madoapp/services/load_local_content.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/balances.dart';
import 'components/info_section.dart';
import 'components/network_switcher.dart';
import 'components/no_recommended_course.dart';
import 'components/recommended_course.dart';
import 'components/testnet_alert.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<HomePageSnapshot>? homepageFutureSnapshot;
  List<Project>? topProjects;
  bool isUserAlreadyHaveWallet = true;
  bool isUserUnlocked = true;
  bool isOnboardingDone = true;
  bool onboardingIsNotOpenNow = true;
  bool? isTestnet;
  String version = '', buildNumber = '';
  void loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    setState(() {});
  }

  void checkIsOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isOnboardingDone = prefs.getBool('is-onboarding-done-2') ?? false;
    });
  }

  Future<void> refreshBalances() async {
    balanceBloc.add(GetBalance());
  }

  void launchRefreshBalancesInterval() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      refreshBalances();
    });
  }

  void loadProjects() async {
    ProjectsApi.getProjects().then((projects) {
      setState(() {
        topProjects = projects;
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  void onNetworkChange(NetworkState event) {
    if (event is! NetworkLoaded) return;
    isTestnet = event.isTestnet;
    if (homepageFutureSnapshot == null) {
      homepageFutureSnapshot = HomepageSnapshotApi.getHomepageSnapshot();
    } else {
      HomepageSnapshotApi.getHomepageSnapshot().then((value) {
        homepageFutureSnapshot = Future.value(value);
        setState(() {});
      });
    }
    setState(() {});
  }

  late StreamSubscription<NetworkState> networkStreamSubs;
  bool isNotificationPermissionLoading = true, isNotificationsAllowed = false;
  void onNotificationsAllowStateChange(NotificationsPermissionState event) {
    if (event is NotificationsPermissionLoaded) {
      isNotificationPermissionLoading = false;
      isNotificationsAllowed = event.isAllowed;
      setState(() {});
    }
  }

  void subscribeNotificationAccessState() {
    onNotificationsAllowStateChange(notificationsPermissionBloc.state);
    notificationsPermissionBloc.stream.listen(onNotificationsAllowStateChange);
  }

  void onUserChange(UserState state) {
    if (state is UserLoaded) {
      setState(() {
        isUserAlreadyHaveWallet = state.userModel.address != null;
        isUserUnlocked = state.userModel.isUnlocked ?? false;
      });
      loadProjects();
      if (state.userModel.isWalletConnectError) {
        ShowPaper.showActionSheet(context, ConnectWalletError());
        userBloc
            .emit(UserLoaded(state.userModel..isWalletConnectError = false));
      }
    }
  }

  @override
  void initState() {
    checkIsOnboardingDone();
    networkStreamSubs = networkBloc.stream.listen(onNetworkChange);
    onNetworkChange(networkBloc.state);
    launchRefreshBalancesInterval();
    loadAppVersion();
    subscribeNotificationAccessState();
    onUserChange(userBloc.state);
    super.initState();
  }

  @override
  void dispose() {
    networkStreamSubs.cancel();
    super.dispose();
  }

  void launchOnboarding() {
    Future.delayed(Duration.zero, () async {
      onboardingIsNotOpenNow = false;
      ShowPaper.showActionSheet(context, const Onboarding(), isClosable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isOnboardingDone && onboardingIsNotOpenNow) {
      launchOnboarding();
    }

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: isTestnet != null
              ? NetworkSwitcher(
                  isTestnet: isTestnet!,
                )
              : Container(),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Bouncing(
                    onPress: () {
                      ShowPaper.showActionSheet(
                          context, ServiceView(url: 'https://mado.one/subs'),
                          isWithPadding: false);
                    },
                    child: AbsorbPointer(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("🏆"),
                      ),
                    )),
              ],
            ),
          ),
          trailing: (isUserUnlocked && !isUserAlreadyHaveWallet)
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Bouncing(
                          onPress: () async {
                            ShowPaper.showActionSheet(
                                context, const ConnectWallet());
                          },
                          child: AbsorbPointer(
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              child: const Text(
                                "👋",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )),
                    ],
                  ),
                )
              : const SizedBox(),
        ),
        child: BlocProvider(
            create: (context) => userBloc,
            child: BlocListener<UserBloc, UserState>(listener:
                (context, state) {
              // if (state is UserError) {
              // ShowPaper.showAlertDialog(
              //     context, state.message ?? "Unknown error");
              // }
              onUserChange(state);
            }, child:
                BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
              if (userState is UserError) {
                return const Center(
                  child:
                      Text("You need internet connection for the first launch"),
                );
              }
              if (userState is UserLoaded) {
                return FutureBuilder<HomePageSnapshot>(
                  future: homepageFutureSnapshot,
                  builder: (context, AsyncSnapshot<HomePageSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || isTestnet == null) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    final allCourses = snapshot.data?.allCourses
                            .where((e) => e.isTestnet == isTestnet)
                            .toList() ??
                        [];
                    final recommendedCourses = allCourses
                        .where((c) =>
                            !c.isNotReady &&
                            !userState.userModel.doneCourses.contains(c.uid))
                        .toList();
                    final recommendedCourse = recommendedCourses.isEmpty
                        ? null
                        : recommendedCourses.first;
                    final isNoRecommendedCourse = recommendedCourses.isEmpty;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          if (isUserUnlocked)
                            Balances(
                              isTestnet: isTestnet!,
                              userAddress: userState.userModel.address,
                              isWalletCourseCompleted: userState
                                  .userModel.doneCourses
                                  .contains(ContentConfig.getWalletCourseUid()),
                            ),
                          const SizedBox(height: 10),
                          if (isUserUnlocked && isTestnet!)
                            const TestnetAlert(),
                          if (topProjects != null &&
                              topProjects!
                                  .where((e) => e.isTestnet == isTestnet)
                                  .toList()
                                  .isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 40),
                                TopServices(
                                    projects: topProjects!
                                        .where((e) => e.isTestnet == isTestnet)
                                        .toList()),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                            child: Column(
                              children: [
                                (isNoRecommendedCourse)
                                    ? const NoRecommendedCourse()
                                    : Column(
                                        children: [
                                          const SizedBox(height: 40),
                                          RecommendedCourse(
                                            course: recommendedCourse,
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          AllCourses(
                            courses: allCourses,
                            doneUids: userState.userModel.doneCourses,
                          ),
                          if (!isNotificationPermissionLoading &&
                              !isNotificationsAllowed)
                            Column(
                              children: [
                                const SizedBox(height: 40),
                                AlertSection(
                                    isNotificationsAllowed:
                                        isNotificationsAllowed),
                              ],
                            ),
                          InfoSection(
                            buildNumber: buildNumber,
                            version: version,
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            }))));
  }
}

class YouHavePremiumPopup extends StatelessWidget {
  const YouHavePremiumPopup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullWidthWithoutPadding =
        MediaQuery.of(context).size.width - 2 * paddingX;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text('You Have Premium Access',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
        ),
        HtmlRender(
            html: LoadLocalContent.getSubsDescription(RuntimeConfig.region)),
        const SizedBox(
          height: 70,
        ),
        BigButton(
            width: fullWidthWithoutPadding,
            text: 'Share',
            backgroundColor: ThemeConfig.kPrimary,
            textFontSize: 18,
            onPress: () {
              Share.share('I Have Premium Access at Mado 😉');
            }),
        const SizedBox(
          height: 20,
        ),
        BigButton(
            width: fullWidthWithoutPadding,
            text: 'Close',
            backgroundColor: Colors.black,
            textFontSize: 18,
            onPress: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
