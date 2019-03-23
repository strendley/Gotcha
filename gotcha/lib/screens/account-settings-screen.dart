import 'package:flutter/material.dart';
import '../widgets/widget-account/accountSettings.dart';

class AccountSettings extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: AccountSettingsPage(title: 'Account Settings'),
    );
  }
}