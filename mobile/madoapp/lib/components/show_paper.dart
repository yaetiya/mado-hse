import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowPaper {
  static void showActionSheet(BuildContext context, Widget content,
      {bool isClosable = true, bool isWithPadding = true}) {
    showModalBottomSheet(
        enableDrag: isClosable,
        isDismissible: isClosable,
        isScrollControlled: true,
        context: context,
        useRootNavigator: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: SizedBox(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  if (isClosable)
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: isWithPadding ? 20 : 10),
                      child: Container(
                        height: 3,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: isWithPadding ? 26 : 0,
                        right: isWithPadding ? 26 : 0,
                        top: isWithPadding ? 30 : 0,
                        bottom: isWithPadding ? 10 : 0),
                    child: content,
                  ),
                ],
              ),
            ),
          );
        });
  }

  static Future<void> showAlertDialog(BuildContext context, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
