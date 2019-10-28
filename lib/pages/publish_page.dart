import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:mqtt/widgets/common_button.dart';
import 'package:mqtt/widgets/common_textfiled.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/util_mqtt.dart';
import '../widgets/common_dialog.dart';
import 'dart:ui';

class PublishPage extends StatefulWidget {
  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  TextEditingController topic = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: window.physicalSize.height / 12),
            child: Center(
              child: Column(
                children: <Widget>[
                  prefix1.Image.asset('images/send.png', width: 50, height: 50,),
                  Text('信息发布', style: prefix1.TextStyle(fontSize: 15),),
                ],
              ),
            ),
          ),
          CommonTextFiled(
              labelText: '主题',
              controller: topic,
              icon: Icon(Icons.supervised_user_circle)),
          CommonTextFiled(
              labelText: '信息', controller: message, icon: Icon(Icons.message)),
          Container(
            width: prefix0.window.physicalSize.width,
            child: RaisedButton(
              onPressed: () {
                MyMqtt().publish(topic.text, message.text);
              },
              child: Text('发布消息'),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          )
        ],
      ),
    );
  }
}
