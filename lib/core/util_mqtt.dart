import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMqtt {
  String _userName;
  String _password;
  String _ip;
  String _id;
  MqttClient client;
  //
  // The caller could call subscribe many times.  Then many subscriptions would be available.
  // in some situations, this will make sense.  For now I limit to one subscription at a time.
  String previousTopic;
  bool bAlreadySubscribed = false;

  Future<bool> subscribeMsg(String topic) async {
    if (await _connectToClient() == true) {
      /// Add the unsolicited disconnection callback
      client.onDisconnected = _onDisconnected;

      /// Add the successful connection callback
      client.onConnected = _onConnected;
      client.onSubscribed = _onSubscribed;
      _subscribe(topic);
    }
    return true;
  }

//
// Connect to Adafruit io
//
  Future<bool> _connectToClient() async {
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
      print('already logged in');
    } else {
      client = await _login();
      if (client == null) {
        return false;
      }
    }
    return true;
  }

  /// The subscribed callback
  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    this.bAlreadySubscribed = true;
    this.previousTopic = topic;
  }

  /// The unsolicited disconnect callback
  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print(':OnDisconnected callback is solicited, this is correct');
    }
    client.disconnect();
  }

  /// The successful connect callback
  void _onConnected() {
    print('OnConnected client callback - Client connection was sucessful');
  }

  void waitRead() {
    _login();
  }

  Future<MqttClient> _login() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    client = MqttClient('${preferences.get('ip')}', '11');
    // Turn on mqtt package's logging while in test.
    client.logging(on: true);
    final MqttConnectMessage connMess = MqttConnectMessage()
        .authenticateAs(
            '${preferences.get('userName')}', '${preferences.get('password')}')
        .withClientIdentifier('dd')
        .keepAliveFor(60) // Must agree with the keep alive set above or not set
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    print('Adafruit client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however eill
    /// never send malformed messages.
    try {
      await client.connect();
    } on Exception catch (e) {
      print('EXCEPTION::client exception - $e');
      client.disconnect();
      client = null;
      return client;
    }

    /// Check we are connected
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('Adafruit client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'Adafruit client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      client = null;
    }
    return client;
  }

//
// Subscribe to the readings being published into Adafruit's mqtt by the energy monitor(s).
//
  Future _subscribe(String topic) async {
    // for now hardcoding the topic
    if (this.bAlreadySubscribed == true) {
      client.unsubscribe(this.previousTopic);
    }
    print('Subscribing to the topic $topic');
    client.subscribe(topic, MqttQos.atMostOnce);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
  }

  String getMsg() {
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      /// The payload is a byte buffer, this will be specific to the topic
      // AdafruitFeed.add(pt);
      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      return pt;
    });
  }

//////////////////////////////////////////
// Publish to an (Adafruit) mqtt topic.
  Future<void> publish(String topic, String value) async {
    // Connect to the client if we haven't already
    if (await _connectToClient() == true) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(value);
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload);
    }
  }
}
