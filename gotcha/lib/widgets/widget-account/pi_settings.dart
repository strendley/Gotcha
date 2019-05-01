import 'package:flutter/material.dart';
import 'homepage.dart';

class PiSettings extends StatefulWidget {
  PiSettings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PiSettingsState createState() => _PiSettingsState();
}

class _PiSettingsState extends State<PiSettings> {
  bool isLightOn = false;
  void onChangedSwitch(bool value) => setState(() => isLightOn = value);

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
        body: new CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverFillRemaining(
              child: new ListView(
              children: <Widget>[
                new Card(
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          child: new ListTile(
                              title: new Text("Light Status"),
                              leading: isLightOn==true?new Icon(Icons.highlight, color:Colors.grey, size:25.0):
                              new Icon(Icons.lightbulb_outline, color:Colors.grey, size:25.0),
                              trailing: new Switch(value: isLightOn, onChanged: onChangedSwitch, activeColor:Colors.blue[700])
                          ),
                        ),
                      ],
                    )

                ),
          ],
        ),
      ),
      ],
    ),
      ),
    );
  }
}
