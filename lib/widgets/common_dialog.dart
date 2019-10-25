import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';


YYDialog alertDialogWithDivider(BuildContext context, String text, Function sureFunc, Function cancelFunc) {
  return YYDialog().build(context)
    ..width = 220
    ..borderRadius = 4.0
    ..text(
      padding: EdgeInsets.all(25.0),
      alignment: Alignment.center,
      text: "$text",
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    )
    ..divider()
    ..doubleButton(
      padding: EdgeInsets.only(top: 10.0),
      gravity: Gravity.center,
      withDivider: true,
      text1: "取消",
      color1: Colors.redAccent,
      fontSize1: 14.0,
      fontWeight1: FontWeight.bold,
      onTap1: () {
        cancelFunc();
      },
      text2: "确定",
      color2: Colors.redAccent,
      fontSize2: 14.0,
      fontWeight2: FontWeight.bold,
      onTap2: () {
        sureFunc();
      },
    )
    ..show();
}

YYDialog successDialogWithDivider(BuildContext context, String text) {
  return YYDialog().build(context)
    ..width = 220
    ..borderRadius = 4.0
    ..text(
      padding: EdgeInsets.all(25.0),
      alignment: Alignment.center,
      text: "$text",
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    )
    ..divider()
    ..doubleButton(
      padding: EdgeInsets.only(top: 10.0),
      gravity: Gravity.center,
      withDivider: true,
      text1: "确定",
      color1: Colors.redAccent,
      fontSize1: 14.0,
      fontWeight1: FontWeight.bold,
    )
    ..show();
}