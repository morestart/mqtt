import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';


class ConnectMqtt {
  
  String _userName;
  String _password;
  String _ip;
  String _id;


  MqttClient client;

  Future readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    
    _userName = preferences.get('userName');
    print('读取到_userName为:$_userName');

    _password = preferences.get('password');
    print('读取到_password为:$_password');

    _ip = preferences.get('ip');
    print('读取到_ip为:$_ip');

    _id = preferences.get('id');
    print('读取到_id为:$_id');
  }

  
}