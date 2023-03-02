import 'package:flutter/services.dart' show rootBundle;

class LoadLocalContent {
  static Map<String, String> subsDescription = {};
  static void init() async {
    subsDescription["en"] =
        await rootBundle.loadString('contents/subsDescription_en.html');
    subsDescription["ru"] =
        await rootBundle.loadString('contents/subsDescription_ru.html');
  }

  static String getSubsDescription(String region) {
    return subsDescription[region] ?? subsDescription["en"]!;
  }
}
