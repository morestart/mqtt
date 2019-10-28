import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mqtt/pages/subscribe_page.dart';
import 'package:mqtt/widgets/common_button.dart';
import 'package:mqtt/widgets/common_textfiled.dart';

class AddSubscribePage extends StatefulWidget {
  @override
  _AddSubscribePageState createState() => _AddSubscribePageState();
}

class _AddSubscribePageState extends State<AddSubscribePage> {
  TextEditingController topicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('添加订阅'),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Container(
        margin: EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //   color: Colors.grey[100],
        // ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                CommonTextFiled(
                    labelText: '主题',
                    controller: topicController,
                    icon: Icon(Icons.supervised_user_circle)),
                Container(
                  width: window.physicalSize.width,
                  child: RaisedButton(
                    onPressed: () {
                      String topic = topicController.text;
                      // SubscribePage().item.add(Text('$topic'));
                      // print(SubscribePage().item);

                      Navigator.of(context).pop('$topic');
                    },
                    child: Text('添加订阅'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
