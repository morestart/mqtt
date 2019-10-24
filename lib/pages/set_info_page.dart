import 'package:flutter/material.dart';
import 'package:mqtt/core/util_mqtt.dart';
import 'package:mqtt/widgets/common_textfiled.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetInfoPage extends StatefulWidget {
  @override
  _SetInfoPageState createState() => _SetInfoPageState();
}

class _SetInfoPageState extends State<SetInfoPage> {

   String _userName;
   String _password;
   String _ip;
   String _id;




  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ipController = TextEditingController();
  TextEditingController idController = TextEditingController();


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

  @override
  void initState() {
    super.initState();
    // 此函数时异步函数,所以直接执行了下面的赋值代码,并没有等待此函数完成赋值后再给textfiled赋值
    // 所以必须等待异步函数执行完毕后进行赋值,否则赋值全为null
    readShared().whenComplete(
      (){
        userNameController.value = TextEditingValue(text: '$_userName');
        passwordController.value = TextEditingValue(text: '$_password');
        ipController.value = TextEditingValue(text: '$_ip');
        idController.value = TextEditingValue(text: '$_id');
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //   color: Colors.grey[100],
        // ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(25),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'images/IOT.png',
                        width: 100,
                        height: 100,
                      ),
                      Text('MQTT Info'),
                    ],
                  ),
                ),
                CommonTextFiled(
                    labelText: '用户名',
                    controller: userNameController,
                    icon: Icon(Icons.supervised_user_circle)),
                CommonTextFiled(
                    labelText: '密码',
                    controller: passwordController,
                    icon: Icon(Icons.verified_user)),
                CommonTextFiled(
                    labelText: 'IP',
                    controller: ipController,
                    icon: Icon(Icons.home)),
                CommonTextFiled(
                    labelText: 'ID',
                    controller: idController,
                    icon: Icon(Icons.card_membership)),
                
                RaisedButton(
                  onPressed: () {

                  },
                  child: Text('conn'),
                  color: Colors.green,
                  textColor: Colors.white,
                ),
              ],
            )
          ],
        ));
  }

  // 存储数据
  Future _onClick() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userName = userNameController.text;
    preferences.setString('userName', userName);
    print('存储userName为:$userName');

    String password = passwordController.text;
    preferences.setString('password', password);
    print('存储password为:$password');

    String ip = ipController.text;
    preferences.setString('ip', ip);
    print('存储ip为:$ip');

    String id = idController.text;
    preferences.setString('id', id);
    print('存储id为:$id');

    
  }

  Future _removeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('userName');
    preferences.remove('password');
    preferences.remove('ip');
    preferences.remove('id');
    print('删除acount成功');
  }
}
