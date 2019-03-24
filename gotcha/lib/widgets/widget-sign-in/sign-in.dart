import 'package:flutter/material.dart';
import 'dart:async';

import '../widget-boxes/username-login-box.dart';
import '../widget-boxes/password-login-box.dart';
import '../../services/authentication.dart';
import '../widget-unknown-account/forgotPassword.dart';
import '../widget-buttons/sign-in-button.dart';
import '../widget-account/widget-account.dart';
import '../widget-account/createAccount.dart';
import '../widget-account/homepage.dart';
class SignIn extends StatefulWidget {
  SignIn({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  _SignInState createState() => new _SignInState();
}

class _SignInState extends State<SignIn> {
  var _email = new TextEditingController();
  var _password = new TextEditingController();

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Failed Sign In"),
          content: new Text("Invalid Email or Password"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _signIn() async {
    try{
      String userId = await widget.auth.signIn(_email.text, _password.text);
      if(userId != null)
      {
        print("user signed in "+ userId );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage())
        );
      }
    }catch(e)
    {
      _showDialog();
      print('ERROR: ' + e.message);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color(0xff314C66)),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: <Widget>[

                  SizedBox(height: 50),
                  Image.asset('gotcha.png'),
                  SizedBox(height: 40),

                
                  Column ( 
                    children: <Widget> [
                      Row(
                      children: <Widget>[
                        Text(
                          'USERNAME',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Color(0xffD9E8FD), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Color(0xffD9E8FD), filled: true,
                      ),
                    ),
                  ]
                  ),
                
                  SizedBox(height: 20,),
                
                  Column ( 
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
                      controller: _password,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Color(0xffD9E8FD), filled: true,
                      ),
                    ),
                  ]
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Forgot password?',
                          style: TextStyle(color: Color(0xffD9E8FD), fontStyle: FontStyle.italic,
                          ),
                        ),
                        onPressed: () =>
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => ForgotPassword(),),
                            ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30,),

                  SizedBox(
                    width: 125,
                    height: 60,
                    child: RaisedButton(
                      color: Color(0xffFFF0D1),
                      onPressed: () =>_signIn(),
                      child: const Text('Sign-in', style: TextStyle(fontSize: 20)),
                    ),
                  ),

                  FlatButton(
                    child: const Text('New Account?',
                      style: TextStyle(color: Color(0xffD9E8FD), fontStyle: FontStyle.italic),
                      //textAlign: TextAlign.right,
                    ),
                    onPressed: () =>
                        Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) => CreateAccount(),),
                  ),),
                  SizedBox(height: 100),
                ]
            ),
          ),
        ),
      ),
    );
  }
}