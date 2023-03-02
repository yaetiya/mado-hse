import 'package:flutter/cupertino.dart';
import 'package:flutter_html/style.dart';

class HtmlConfig {
  static final styleConfig = {
    "body": Style(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        lineHeight: LineHeight.percent(120)),
    "html": Style(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
    ),
    "p": Style(
        fontSize: const FontSize(16), lineHeight: LineHeight.percent(120)),
    "li": Style(
        fontSize: const FontSize(16), lineHeight: LineHeight.percent(120)),
  };
}
