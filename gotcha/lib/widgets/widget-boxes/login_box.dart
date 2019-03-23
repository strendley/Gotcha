import 'package:flutter/material.dart';

class LoginInBox extends StatelessWidget {
  final String title;

  LoginInBox({Key key, this.title}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column ( 
      children: <Widget> [
      new Row(
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(color: Color(0xffD9E8FD), fontWeight: FontWeight.bold),
          ),
        ],
      ),
      TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          fillColor: Color(0xffD9E8FD), filled: true,
        ),
      ),
    ]
    );
  }
}
  