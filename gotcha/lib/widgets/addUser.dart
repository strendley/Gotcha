import 'package:flutter/material.dart';

class AddUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: AddUser(title: 'Picture Test'),
    );
  }
}

class AddUser extends StatefulWidget {
  AddUser({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          leading: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);}),
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
