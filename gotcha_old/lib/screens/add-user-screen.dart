import 'package:flutter/material.dart';
import '../widgets/widget-account/add_user.dart';

class AddUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: AddUser(),
    );
  }
}