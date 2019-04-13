import 'package:flutter/material.dart';

class PiSettings extends StatefulWidget {
  PiSettings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PiSettingsState createState() => _PiSettingsState();
}

class _PiSettingsState extends State<PiSettings> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Pi Settings',
      theme: ThemeData(
        primaryColor: Color(0xff314c66),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);}),
          title: Text('Pi Settings'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
