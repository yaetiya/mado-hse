import 'dart:io';

class RuntimeConfig {
  static late String region;
  static String platform = Platform.isAndroid ? "android" : 'ios';
}
