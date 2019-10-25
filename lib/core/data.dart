import 'package:shared_preferences/shared_preferences.dart';

class Data {
  Future _removeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('userName');
    preferences.remove('password');
    preferences.remove('ip');
    preferences.remove('id');
    print('删除acount成功');
  }
}
