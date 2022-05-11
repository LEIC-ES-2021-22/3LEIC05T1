import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastMessage {
  static const Color toastColor = Color.fromARGB(255, 100, 100, 100);
  display(BuildContext context, String msg) {
    ToastContext().init(context);

    Toast.show(
      msg,
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
      backgroundColor: toastColor,
      backgroundRadius: 16.0,
      textStyle: TextStyle (color: Colors.white)
    );
  }
}
