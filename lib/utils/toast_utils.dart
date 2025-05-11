import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastUtils {
  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: "🎉 $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: "⚠ $message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
