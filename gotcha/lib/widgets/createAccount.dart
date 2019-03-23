import 'package:flutter/material.dart';
import 'personalInfo.dart';

class CreateAccountPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: CreateAccount(title: 'Create Account'),
    );
  }
}

class CreateAccount extends StatefulWidget {
  CreateAccount({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreateAccount createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {
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
                      'Create Account',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                new Row(
                  children: <Widget>[
                    Text(
                      'Username',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  //obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white, filled: true,
                  ),
                ),

                SizedBox(height: 10),

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
                  //obscureText: true,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => PersonalInfo(),),
                        ),
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
