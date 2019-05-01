import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'widgets/widget-sign-in/sign-in.dart';
import './services/authentication.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gothca App',
      theme: ThemeData(
          //primaryColor: Colors.blue
          primaryColor: Color(0xffECEAD3)
      ),
      home:  SignIn(auth: new Auth()),
    );
  }
}
//*/