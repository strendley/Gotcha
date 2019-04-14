import 'package:flutter/material.dart';
import '../widgets/widget-account/personalInfo.dart';

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
