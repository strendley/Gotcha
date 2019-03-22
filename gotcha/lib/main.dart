import 'package:flutter/material.dart';
//import 'package:splashscreen/splashscreen.dart';
import 'homepage.dart';
import 'createAccount.dart';
import 'forgotPassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(gotcha());

class gotcha extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
        //primaryColor: Color(0xffECEAD3)
      ),
      home: signin(title: 'Account Settings'),
    );
  }
}

class signin extends StatefulWidget {
  signin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _signinState createState() => _signinState();
}

class _signinState extends State<signin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        //automaticallyImplyLeading: false,
        //appBar: AppBar(title: Text('Gotcha')),
        body: Container(
          decoration: BoxDecoration(color: Color(0xff314C66)),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            //decoration: BoxDecoration(color: Color(0xff314C66)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: <Widget>[

                  SizedBox(height: 50),
                  Image.asset('gotcha.png'),
                  SizedBox(height: 40),
                  new Row(
                    children: <Widget>[
                      Text(
                        'USERNAME',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xffD9E8FD), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  //Container(
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color(0xffD9E8FD), filled: true,
                    ),
                  ),
                  //),
                  SizedBox(height: 20,),
                  new Row(
                    children: <Widget>[
                      Text(
                        'PASSWORD',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xffD9E8FD), fontWeight: FontWeight.bold),

                      ),
                    ],
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Color(0xffD9E8FD), filled: true,
                    ),
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
                              //MaterialPageRoute(builder: (context) => AddUser())); },
                              MaterialPageRoute(builder: (BuildContext context) => ForgotPassword(),),
                            ),
                        //onPressed: (),

                      ),
                    ],
                  ),

                  SizedBox(height: 30,),

                  SizedBox(
                    width: 125,
                    height: 60,
                    child: RaisedButton(
                      color: Color(0xffFFF0D1),
                      onPressed: () =>
                          Navigator.push(
                            context,
                            //MaterialPageRoute(builder: (context) => AddUser())); },
                            MaterialPageRoute(builder: (BuildContext context) => MyHomePage(),),
                          ),
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