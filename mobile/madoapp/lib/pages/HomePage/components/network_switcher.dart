import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:madoapp/blocs/network/network_bloc.dart';
import 'package:madoapp/blocs/network/network_event.dart';


class NetworkSwitcher extends StatefulWidget {
  final bool isTestnet;
  const NetworkSwitcher({Key? key, required this.isTestnet}) : super(key: key);

  @override
  State<NetworkSwitcher> createState() => _NetworkSwitcherState();
}

class _NetworkSwitcherState extends State<NetworkSwitcher> {
  @override
  Widget build(BuildContext context) {
    int _tabSelectedIndexSelected = (widget.isTestnet) ? 0 : 1;

    return FlutterToggleTab(
      isShadowEnable: false,
      width: 40,
      borderRadius: 30,
      height: 28,
      selectedIndex: _tabSelectedIndexSelected,
      selectedBackgroundColors: const [Colors.white],
      selectedTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 13,
      ),
      unSelectedTextStyle: const TextStyle(color: Colors.black54, fontSize: 13),
      labels: const ['Testnet', 'Mainnet'],
      selectedLabelIndex: (index) {
        if (index != _tabSelectedIndexSelected) {
          networkBloc.add(SwitchNetwork());
        }
      },
      isScroll: false,
      marginSelected: const EdgeInsets.all(2),
    );
  }
}
