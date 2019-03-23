import 'package:flutter/material.dart';
import '../widgets/widget-unknown-account/forgotPassword.dart';

class ForgotPasswordPage extends StatelessWidget {
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