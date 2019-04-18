import 'package:flutter/material.dart';
import 'homepage.dart';


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
        backgroundColor: Color(0xff314c66),
        appBar: AppBar(
          leading: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);}),
          title: Text('About'),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
              icon: Image.asset("gotcha.png"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => Home(),),
                );
              },
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Text('Gotcha was designed and developed by a small team of undergradute students at MST.'
              ' The project was done for Software Systems Development, a class taught by our lord and savior,'
              ' Mr. Gilbert Gosenell.',textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xffD9E8FD), fontWeight: FontWeight.bold, fontSize: 18),),
        ),
      ),
      ),
    );
  }
}
