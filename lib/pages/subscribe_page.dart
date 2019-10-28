import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:mqtt/pages/add_subscribe_page.dart';

TextEditingController inputContent = TextEditingController();

class SubscribePage extends StatefulWidget {
  final List<String> item = [];

  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // itemExtent: 50.0,
            itemCount: widget.item.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                trailing: IconButton(
                  onPressed: (){
                    
                    setState(() {
                      // TODO: 取消订阅
                      widget.item.removeAt(index);
                    });
                    print(widget.item);
                  },
                  icon: Icon(Icons.cancel),
                ),
                leading: prefix0.Image.asset('images/topic.png', width: 24, height: 24, color: Colors.black38,),
                title: Text('${widget.item[index]}'),
                dense: true,
                onLongPress: () {},
              );
            },
          ),
          Container(
            width: window.physicalSize.width,
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (BuildContext context) => AddSubscribePage()))
                    .then((data) {
                  setState(() {
                    widget.item.add(data);
                    // TODO: 添加订阅
                    print(widget.item);
                  });
                });
              },
              child: Text('添加订阅'),
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
