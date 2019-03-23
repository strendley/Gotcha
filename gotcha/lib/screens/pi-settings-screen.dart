import 'package:flutter/material.dart';
import '../widgets/widget-account/pi_settings.dart';
class PiSettingsPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: PiSettings(title: 'Pi Settings'),
    );
  }
}
