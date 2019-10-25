import 'package:flutter/material.dart';

class CommonButton extends StatefulWidget {
  final Function f;
  final String text;
  final Color color;
  final Color textColor;
  final double width;
  final EdgeInsets margin; 

  const CommonButton(
      {Key key, this.f, this.text, this.color, this.textColor, this.width, this.margin})
      : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: widget.width,
      child: RaisedButton(
        onPressed: widget.f,
        child: Text('${widget.text}'),
        color: widget.color,
        textColor: widget.textColor,
      ),
    );
  }
}
