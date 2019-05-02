import 'package:flutter/material.dart';
import 'homepage.dart';

class PiSettings extends StatefulWidget {
  PiSettings({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

  @override
  _PiSettingsState createState() => _PiSettingsState();
}

class _PiSettingsState extends State<PiSettings> {
  bool isLightOn = false;
  void onChangedSwitch(bool value) => setState(() => isLightOn = value);

  bool bluetooth = true;
  void onChangedtooth(bool value) => setState(() => bluetooth = value);

  bool delay = false;
  void onChangeddelay(bool value) => setState(() => delay = value);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Camera Settings',
      theme: ThemeData(
        primaryColor: Color(0xff314c66),
      ),
      home: Scaffold(
        backgroundColor: Color(0xff314c66),
        appBar: AppBar(
          leading: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);}),
          title: Text('Camera Settings'),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
              icon: Image.asset("gotcha.png"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => Home(email: widget.email),),
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

                SizedBox(height: 20),

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

                new Card(
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          child: new ListTile(
                              title: new Text("Bluetooth Identification"),
                              leading: bluetooth==true?new Icon(Icons.bluetooth, color:Colors.grey, size:25.0):
                              new Icon(Icons.bluetooth_disabled, color:Colors.grey, size:25.0),
                              trailing: new Switch(value: bluetooth, onChanged: onChangedtooth, activeColor:Colors.blue[700])
                          ),
                        ),
                      ],
                    )
                ),

                new Card(
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          child: new ListTile(
                              title: new Text("Automatic Delayed Lock"),
                              leading: delay==true?new Icon(Icons.timer, color:Colors.grey, size:25.0):
                              new Icon(Icons.timer_off, color:Colors.grey, size:25.0),
                              trailing: new Switch(value: delay, onChanged: onChangeddelay, activeColor:Colors.blue[700])
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
