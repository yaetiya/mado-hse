import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bouncing.dart';

class BigButton extends StatelessWidget {
  const BigButton(
      {Key? key,
      required this.width,
      required this.text,
      required this.backgroundColor,
      required this.onPress,
      this.textFontSize = 22})
      : super(key: key);

  final double width;
  final String text;
  final double textFontSize;
  final Color backgroundColor;
  final void Function() onPress;
  @override
  Widget build(BuildContext context) {
    return Bouncing(
      onPress: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 56,
        width: width,
        child: Center(
          child: Text(text,
              style: TextStyle(fontSize: textFontSize, color: Colors.white)),
        ),
      ),
    );
  }
}
