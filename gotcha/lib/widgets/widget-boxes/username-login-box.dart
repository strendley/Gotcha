import 'package:flutter/material.dart';

class UsernameLoginInBox extends StatelessWidget {
  final String title;
  final TextEditingController username;
  
  UsernameLoginInBox({Key key, this.title, this.username}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return new Column ( 
      children: <Widget> [
        Row(
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
  