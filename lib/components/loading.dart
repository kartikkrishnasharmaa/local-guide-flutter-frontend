import 'package:localguider/components/custom_text.dart';
import 'package:localguider/main.dart';
import 'package:localguider/responsive.dart';
import 'package:flutter/material.dart';

class Loading {
  static bool _isShowing = false;

  static void show(BuildContext? context) {
    if (_isShowing) return;
    _isShowing = true;
    if (context == null) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => MyProgressDialog(message: 'Please wait...'),
    );
  }

  static void hide(BuildContext? context) {
    if (context == null) return;
    if (!_isShowing) return;
    _isShowing = false;
    navigatePop(context);
  }
}

class MyProgressDialog extends StatefulWidget {
  final String message;

  MyProgressDialog({required this.message});

  @override
  _MyProgressDialogState createState() => _MyProgressDialogState();
}

class _MyProgressDialogState extends State<MyProgressDialog> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        backgroundColor: $styles.colors.white,
        children: [
          Padding(
            padding: EdgeInsets.only(top: sizing(10, context), bottom: sizing(10, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(color: $styles.colors.title,),
                ),
                gap(context, width: 15),
                CustomText(widget.message, color: $styles.colors.title),
              ],
            ),
          )
        ],
      ),
    );
  }
}
