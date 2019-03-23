import 'package:flutter/material.dart';
import '../../services/authentication.dart';
import '../widget-account/personalInfo.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key key, this.title, this.auth}) : super(key: key);
  final BaseAuth auth;
  final String title;

  @override
  _CreateAccount createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {
  var _email = new TextEditingController();
  var _password = new TextEditingController();
  var _check_password = new TextEditingController();

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Failed Sign Up"),
          content: new Text("Passwords for " + _email.text+" are not the same " +_password.text +" != " +_check_password.text),
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

  Future _signUp() async {
    try{
      String userId = await Auth().signUp(_email.text, _password.text);
      if(userId != null)
      {
        print("user signed in "+ userId );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => PersonalInfo())
        );
      }
    }catch(e)
    {
      _showDialog();
      print(e);
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Gotcha')),
        body: Container(
          decoration: BoxDecoration(color: Color(0xffD9E8FD)),
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

                SizedBox(height: 100),

              ],
            ),
          ),

        ),
      ),
    );
  }

}
