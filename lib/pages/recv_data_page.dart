import 'package:flutter/material.dart';
import 'package:mqtt/core/util_mqtt.dart';



class GetRecvData extends StatefulWidget {
  @override
  _GetRecvDataState createState() => _GetRecvDataState();
}

class _GetRecvDataState extends State<GetRecvData> {
  String msg;
  

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    msg = MyMqtt().getMsg();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('$msg'),
    );
  }
}