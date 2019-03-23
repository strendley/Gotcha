import 'package:flutter/material.dart';
import '../widgets/widget-account/widget-account.dart';

class AccountPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: Account(title: 'Account Settings'),
    );
  }
}
