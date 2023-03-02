import 'package:flutter/cupertino.dart';

class ScreenSizeService {
  static isBigScreen(BuildContext context) =>
      MediaQuery.of(context).size.width > 600;
}
