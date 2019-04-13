import 'package:flutter/material.dart';

class FeaturesPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Color(0xff314c66)
      ),
      home: Features(title: 'Features'),
    );
  }
}

class Features extends StatefulWidget {
  Features({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FeaturesState createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Features',
      theme: ThemeData(
          primaryColor: Color(0xff314c66)
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);}),
          title: Text('Features'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
