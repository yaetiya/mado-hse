import 'package:madoapp/models/runtime_config.dart';

class ContentConfig {
  static const kOnboardingCourseUids = {
    'en': "62ed3a9f899af4914dd7c90e",
    'ru': "62f3a9c43480b31b97874a04"
  };
  static const kWalletCourseUids = {
    'en': "62f3aa2b3480b31b97874a21",
    'ru': "62ee469f899af4914dd7cb61"
  };
  static getWalletCourseUid() =>
      kWalletCourseUids[RuntimeConfig.region] ?? kOnboardingCourseUids["en"];
  static getOnboardingCourseUid() =>
      kOnboardingCourseUids[RuntimeConfig.region] ??
      kOnboardingCourseUids["en"];
}
