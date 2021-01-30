import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Function onPressed;

  const BlueButton(
      {Key key,
      @required this.text,
      @required this.backgroundColor,
      @required this.textColor,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        elevation: 2,
        highlightElevation: 5,
        color: this.backgroundColor,
        shape: StadiumBorder(),
        child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text(
              this.text,
              style: TextStyle(color: this.textColor, fontSize: 17),
            ),
          ),
        ),
        onPressed: this.onPressed);
  }
}
