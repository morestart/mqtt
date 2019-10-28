import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';
import 'package:typed_data/typed_buffers.dart';

class MyMqtt {
  String _userName;
  String _password;
  String _ip;
  String _id;
  MqttClient client;
  MqttConnectionState connectionState;
  StreamSubscription subscription;

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
      _connect();
    });
  }

  
  void _connect() async 
  {
    client = MqttClient(_ip, _id);
    client.logging(on: false);
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;
    final MqttConnectMessage connectMessage = MqttConnectMessage()
          .withClientIdentifier(_id)
          .startClean()
          .keepAliveFor(30)
          .withWillQos(MqttQos.atMostOnce);
    print('MQTT connecting');
    client.connectionMessage = connectMessage;

    try
    {
      await client.connect(_userName, _password);
    } catch (e) {
      print(e);
      _disconnect();
    }

    if (client.connectionState == MqttConnectionState.connected) {
      print('connected');
      print(client.connectionStatus);
      connectionState = client.connectionState;
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    subscription = client.updates.listen(_onMessage);
    
  }

  void _subscribeTopic(String topic) 
  {
    if (connectionState == MqttConnectionState.connected)
    {
      print('[MQTT client] Subscribing to ${topic.trim()}');
      client.subscribe(topic, MqttQos.exactlyOnce);
    }
  }

 
  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    // setState(() {
      //topics.clear();
      connectionState = client.connectionState;
      client = null;
      subscription.cancel();
      subscription = null;
    // });
    print('[MQTT client] MQTT client disconnected');
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    print(event.length);
    final MqttPublishMessage recMess =
    event[0].payload as MqttPublishMessage;
    final String message =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: ${message}");
    // setState(() {
    //   _temp = double.parse(message);
    // });
  }
}
