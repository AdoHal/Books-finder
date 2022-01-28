import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastWidget {
  void showToast(String msg, Color bGcolor, Color textColor, Toast length){
    Fluttertoast.showToast(
        msg: msg.isEmpty ? "Something went wrong. Check your internet connection and try again later." : msg,
        toastLength: length,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bGcolor,
        textColor: textColor,
        fontSize: 16.0
    );
  }
}