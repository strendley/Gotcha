import 'package:flutter/material.dart';
import 'homepage.dart';

class forgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: ForgotPassword(title: 'Create Account'),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ForgotPassword createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
        appBar: AppBar(title: Text('Gotcha')),
    body: Container(
    decoration: BoxDecoration(color: Color(0xff314C66)),
    child: SingleChildScrollView(
    padding: EdgeInsets.all(30),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,

    children: <Widget>[

      SizedBox(height: 175),

      new Row(
        children: <Widget>[
          Text(
            'Please enter email',
            textAlign: TextAlign.left,
            style: TextStyle(color: Color(0xffD9E8FD), fontWeight: FontWeight.bold,),
          ),
        ],
      ),

      TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          fillColor: Color(0xffD9E8FD), filled: true,
        ),
      ),

      SizedBox(height: 30),

      SizedBox(
        width: 125,
        height: 60,
        child: RaisedButton(
          color: Color(0xffFFF0D1),
          onPressed: () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => MyHomePage(),),
              ),
          child: const Text('Send Email', style: TextStyle(fontSize: 15)),
        ),
      ),

      SizedBox(height: 160),

    ],
    ),
    ),

    ),
        ),
    );
  }

}