import 'package:flutter/material.dart';
import '../widgets/widget-camera/test_pictures.dart';

class PicturesPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: Pictures(title: 'Picture Test'),
    );
  }
}