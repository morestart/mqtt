import 'package:flutter/material.dart';
import 'package:mqtt/pages/publish_page.dart';
import 'package:mqtt/pages/recv_data_page.dart';
import 'package:mqtt/pages/set_info_page.dart';
import 'package:mqtt/pages/subscribe_page.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNav(),
    );
  }
}

// 导航
class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('服务器')),
    BottomNavigationBarItem(icon: Icon(Icons.subscriptions), title: Text('订阅')),
    BottomNavigationBarItem(icon: Icon(Icons.publish), title: Text('发布')),
    BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('信息'))
  ];

  final bodyList = [
    SetInfoPage(),
    SubscribePage(),
    PublishPage(),
    GetRecvData(),
  ];

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MQTTol'),
      ),
      body: bodyList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: items,
        currentIndex: _currentIndex,
        onTap: onTap,
      ),
      // floatingActionButton: _currentIndex == 1
      //     ? Builder(builder: (BuildContext context) {
      //         return FloatingActionButton(
      //           child: Icon(Icons.add),
      //           onPressed: () {
      //             SubscribePage().list.add(
      //               Text('data')
      //             );
      //             print('ok');
      //           },
      //         );
      //       })
      //     : null,
    );
  }
}
