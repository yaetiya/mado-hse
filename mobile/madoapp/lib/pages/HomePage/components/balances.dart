import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/blocs/balance/balance_bloc.dart';
import 'package:madoapp/blocs/balance/balance_state.dart';
import 'package:madoapp/components/connect_wallet.dart';
import 'package:madoapp/components/custom_divider.dart';
import 'package:madoapp/components/show_paper.dart';
import 'package:madoapp/configs/content_config.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:madoapp/models/user_balances.dart';
import 'package:madoapp/pages/CoursePage/course_page.dart';
import 'package:madoapp/routes/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:madoapp/tools/web3_tools.dart';

class Balances extends StatefulWidget {
  final String? userAddress;
  final bool isWalletCourseCompleted;
  final bool isTestnet;
  const Balances(
      {Key? key,
      this.userAddress,
      required this.isWalletCourseCompleted,
      required this.isTestnet})
      : super(key: key);

  @override
  State<Balances> createState() => _BalancesState();
}

class _BalancesState extends State<Balances> {
  UserBalance balances = const UserBalance('0', '0', '0', '0', '0');
  void onBalanceChange(BalanceState event) {
    if (widget.userAddress == null) {
      return;
    }
    if (event is BalanceLoaded) {
      balances = event.balanceModel;
      setState(() {});
    }
    if (event is BalanceError) {
      balances = const UserBalance('~', '~', '~', '~', '~');
      setState(() {});
    }
  }

  late StreamSubscription<BalanceState> balanceStreamSubs;
  @override
  void initState() {
    onBalanceChange(balanceBloc.state);
    balanceStreamSubs = balanceBloc.stream.listen(onBalanceChange);
    super.initState();
  }

  @override
  void dispose() {
    balanceStreamSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maticBalance =
        widget.isTestnet ? balances.maticTestnet : balances.maticMainnet;
    final ethBalance =
        widget.isTestnet ? balances.ethTestnet : balances.ethMainnet;
    final usdBalance = widget.isTestnet ? '0' : balances.totalUsdBalance;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        child: Stack(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: ethBalance,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: ' ETH' +
                                (widget.isTestnet ? ' (Kovan testnet)' : '')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: maticBalance,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: ' MATIC' +
                                (widget.isTestnet ? ' (Mumbai testnet)' : '')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const CustomDivider(),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: usdBalance,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28)),
                        const TextSpan(
                            text: ' USD', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      Web3Tools.cropAddress(
                          widget.userAddress ?? "0x000000000000000000"),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey)),
                ]),
          ),
          if (widget.userAddress == null)
            Positioned.fill(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: const Color(0x77DDDDDD),
                ),
              ),
            )),
          if (widget.userAddress == null)
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .completeWalletCourseAlert1,
                        ),
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .completeWalletCourseAlert2,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.isWalletCourseCompleted
                                    ? ShowPaper.showActionSheet(
                                        context, const ConnectWallet())
                                    : Navigator.of(context, rootNavigator: true)
                                        .pushNamed(
                                        CoursePage.routeName,
                                        arguments: ScreenArguments(
                                          ContentConfig.getWalletCourseUid(),
                                        ),
                                      );
                              },
                            style: const TextStyle(
                              color: ThemeConfig.kPrimary,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
