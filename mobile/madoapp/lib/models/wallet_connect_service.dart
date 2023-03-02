import 'package:flutter/cupertino.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
// import 'package:algorand_dart/algorand_dart.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletConnectService {
  // "wc:8a5e5bdc-a0e4-4702-ba63-8f1a5655744f@1?bridge=https%3A%2F%2Fbridge.walletconnect.org&key=41791102999c339c844880b23950704cc43aa840f3739e365323cda4dfa89e7a"
  static const String walletConnectTestUrl = 'wc:j2ikwwtest';
  static late String _address;
  static late WalletConnect connector;
  static Future killSession() {
    return connector.killSession();
  }

  static Future<String> createSession() async {
    if (!connector.connected) {
      bool isAbleToOpenWallet = await canLaunch(walletConnectTestUrl);
      if (!isAbleToOpenWallet) {
        throw Exception("WalletConnect is not installed");
      }
      final session = await connector.createSession(
        chainId: 1,
        onDisplayUri: (url) async {
          isAbleToOpenWallet = (url != null && await canLaunch(url));
          if (url != null && await canLaunch(url)) {
            await launch(url);
          }
        },
      );

      return session.accounts[0];
    }
    throw Exception('Already connected');
  }

  static Future<String?> checkWalletConnect() async {
    // Define a session storage
    final sessionStorage = WalletConnectSecureStorage();
    final session = await sessionStorage.getSession();

    // Create a connector
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      session: session,
      sessionStorage: sessionStorage,
      clientMeta: const PeerMeta(
        name: 'Mado',
        description: 'WalletConnect Developer App',
        url: 'Mado',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    if (session?.accounts.isNotEmpty ?? false) {
      _address = session!.accounts[0];
      return _address;
    }
  }

  static Future<String?> initWalletConnect() async {
    try {
      _address = await createSession();
      return _address;
    } catch (e) {
      debugPrint('wc');
      debugPrint(e.toString());
      return null;
    }
  }
}
