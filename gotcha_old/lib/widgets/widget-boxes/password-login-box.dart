import 'package:flutter/material.dart';

class PasswordLoginInBox extends StatefulWidget {
  @override
  _PasswordLoginInBoxState createState() => _PasswordLoginInBoxState();
}

class _PasswordLoginInBoxState extends State<PasswordLoginInBox>{
  final password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Column ( 
      children: <Widget> [
        Row(
        children: <Widget>[
          Text(
            'PASSWORD',
            textAlign: TextAlign.left,
            style: TextStyle(color: Color(0xffD9E8FD), fontWeight: FontWeight.bold),
          ),
        ],
      ),
      TextField(
        controller: password,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          fillColor: Color(0xffD9E8FD), filled: true,
        ),
      ),
    ]
    );
  }
}
  