import 'package:flutter/material.dart';
import '../../services/authentication.dart';
import '../widget-account/personalInfo.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CreateAccount createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {
  var _email = new TextEditingController();
  var _password = new TextEditingController();
  var _check_password = new TextEditingController();
  BaseAuth _auth;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Failed Sign Up"),
          content: new Text("Passwords for " + _email.text+" are not the same " +_password.text +" != " +_check_password.text),
          actions: <Widget>[
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

  Future _signUp() async {
    try{
      if(_password.text ==_check_password.text)
      {
        String userId = await Auth().signUp(_email.text, _password.text);
        if(userId != null)
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => PersonalInfo(email: _email.text))
          );
        }
      }
      else
      {
        _showDialog();
      }
    }catch(e)
    {
      print(e);
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff314C66),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Gotcha'),
          actions: <Widget>[
            new IconButton(
              icon: Image.asset("gotcha.png"),
              onPressed: () {

              },
            ),
          ],

        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey[100]),//(0xffD9E8FD)),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: <Widget>[
                new Row(
                  children: <Widget>[
                    Text(
                      'Sign Up',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                new Row(
                  children: <Widget>[
                    Text(
                      'Email',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Password',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Confirm Password',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: _check_password,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 50),

                SizedBox(
                  width: 125,
                  height: 60,
                  child: RaisedButton(
                    color: Color(0xffFFF0D1),
                    onPressed: () =>
                        _signUp(),
                    child: const Text('Next', style: TextStyle(fontSize: 20)),
                  ),
                ),

                SizedBox(height: 150),

              ],
            ),
          ),

        ),
      ),
    );
  }

}
