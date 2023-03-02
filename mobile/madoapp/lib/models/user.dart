import 'dart:convert';

import 'package:madoapp/models/wallet_connect_service.dart';

class AuthService {
  static Future<String?> initWalletConnect() async {
    String? address = await WalletConnectService.initWalletConnect();
    return address;
  }
}

class User {
  User();
  User.withParams(this.accessToken, this.address, this.doneCourses);
  late String accessToken;
  bool isWalletConnectError = false;
  String? address;
  late List<String> doneCourses;
  bool? isUnlocked;
  toJson() {
    return {
      'accessToken': accessToken,
      'address': address,
      'isUnlocked': isUnlocked,
      'doneCourses': jsonEncode(doneCourses)
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    doneCourses = List<String>.from(((json['doneCourses'].runtimeType == String)
            ? jsonDecode(json['doneCourses'])
            : json['doneCourses'] as List)
        .toList());
    isUnlocked = json['isUnlocked'];
    address = json['address'];
  }
}
