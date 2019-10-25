import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';
import 'package:typed_data/typed_buffers.dart';

class Mqtt {
  String _userName;
  String _password;
  String _ip;
  String _id;

  MqttClient mqttClient;
  static Mqtt _instance;

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

  void waitRead() {
    readShared().whenComplete(() {
      Mqtt._();
      connect();
    });
  }

  Mqtt._() {
    mqttClient = MqttClient(_ip, _id);

    ///连接成功回调
    mqttClient.onConnected = _onConnected;

    ///连接断开回调
    mqttClient.onDisconnected = _onDisconnected;

    ///订阅成功回调
    mqttClient.onSubscribed = _onSubscribed;

    ///订阅失败回调
    mqttClient.onSubscribeFail = _onSubscribeFail;
  }

  static Mqtt getInstance() {
    if (_instance == null) {
      _instance = Mqtt._();
    }
    return _instance;
  }

  connect() {
    mqttClient.connect(_userName, _password);
    print('连接成功');
  }

  disconnect()
  {
    mqttClient.disconnect();
  }

  publishMessage(String topic, String msg, MqttQos qos) 
  {
    ///int数组
    Uint8Buffer uint8buffer = Uint8Buffer();
    ///字符串转成int数组 (dart中没有byte) 类似于java的String.getBytes?
    var codeUnits = msg.codeUnits;
    //uint8buffer.add()
    uint8buffer.addAll(codeUnits);
    mqttClient.publishMessage(topic, qos, uint8buffer);
  }

  ///消息监听
  _onData(List<MqttReceivedMessage<MqttMessage>> data) {
    Uint8Buffer uint8buffer = Uint8Buffer();
    var messageStream = MqttByteBuffer(uint8buffer);
    data.forEach((MqttReceivedMessage<MqttMessage> m) {
      ///将数据写入到messageStream数组中
      m.payload.writeTo(messageStream);
      ///打印出来
      print(uint8buffer.toString());
    });
  }

  _onConnected()
  {
    // mqttClient.subscribe(topic, qosLevel)
  }

  _onDisconnected()
  {

  }

  _onSubscribed(String topic) 
  {
    mqttClient.updates.listen(_onData);
  }

  _onSubscribeFail(String topic)
  {

  }

}
