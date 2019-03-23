import 'package:flutter/material.dart';
import 'homepage.dart';

class PersonalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: PersonalInfo(title: 'Create Account'),
    );
  }
}

class PersonalInfo extends StatefulWidget {
  PersonalInfo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PersonalInfo createState() => _PersonalInfo();
}

class _PersonalInfo extends State<PersonalInfo> {
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
                      'First Name',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white, filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Last Name',
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
                      'Address',
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
                      'Phone number',
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
                          MaterialPageRoute(builder: (BuildContext context) => MyHomePage(),),
                        ),
                    child: const Text('Finish', style: TextStyle(fontSize: 20)),
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