import 'package:flutter/material.dart';
import 'add_user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

//void main() => runApp(MyApp());

class TestCameraPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TestCamera(title: 'Test Pictures Page'),
    );
  }
}

class TestCamera extends StatefulWidget {
  TestCamera({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TestCameraState createState() => _TestCameraState();


}

class _TestCameraState extends State<TestCamera> {

  File _image;
  Future getImageFromCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Pictures',
      home: Scaffold(
        appBar: AppBar(
          leading: new IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: () {Navigator.pop(context);}),
          title: Text('Test Pictures'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top:10.0),
                child: new Align(
                  alignment: Alignment.topCenter,
                  child: new Text('Test Your Setup With a Picture!', style: new TextStyle(fontSize: 26),)
                ),
              ),

              new Padding(
                padding: EdgeInsets.only(top:15.0),
                child: new Align(
                  alignment: Alignment.topCenter,
                child: new Text('click the image to crop', style: new TextStyle(fontSize: 15),)
                ),
              ),

              new Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    alignment: Alignment.center,
                    child: new FadeInImage(placeholder: AssetImage('user-placeholder.png'), image: AssetImage('user-placeholder.png')),
                    //new Image.asset('user-placeholder.png'),
                    height: 250.0,
                    width: 250.0,
                  ),
                ],
              ),

              new Row(
                children: <Widget>[
                  new Expanded(
                      child: Padding(
                        child: RaisedButton(
                          child: Text("Gallery", style: new TextStyle(fontSize: 20),),
                          onPressed: () {getImageFromGallery();},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)
                          ),
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                      )
                  ),
                  new Expanded(
                      child: Padding(
                        child: RaisedButton(
                          child: Text("Camera", style: new TextStyle(fontSize: 20),),
                          onPressed: () {getImageFromCam();},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                        padding: EdgeInsets.only(left: 7, right: 7),
                      )
                  ),
                ],
              ),


              new Padding(
                  padding: EdgeInsets.only(top:7.0),
                  //child: new Align(
                  //alignment: Alignment.topCenter,
                  //child: new Text('Results: ', style: new TextStyle(fontSize: 25),)
                //),
              ),

              new Row(
                children: <Widget>[
                  new Expanded(
                    child: Padding(
                      child: RaisedButton(
                        child: Text("Test Picture!", style: new TextStyle(fontSize: 20),),
                        onPressed: () => null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)
                        ),
                      ),
                      padding: EdgeInsets.only(left: 7, right: 7),
                    )
                  ),
                ],
              ),

              new Padding(
                padding: EdgeInsets.only(top:15.0),
                //child: new Align(
                    //alignment: Alignment.topCenter,
                    child: new Text('Results: ', style: new TextStyle(fontSize: 25),)
                //),
              ),

              new Padding(
                  padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                  //child: new Align(
                  //alignment: Alignment.topCenter,
                  child: new Text('<RESULT OF TEST>', style: new TextStyle(fontSize: 25, color: Colors.red),)
                //),
              ),

              new Row(
                children: <Widget>[
                  new Expanded(
                      child: Padding(
                        child: RaisedButton(
                          child: Text("Return to Menu", style: new TextStyle(fontSize: 20),),
                          onPressed: () { Navigator.pop(context);},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)
                          ),
                        ),
                        padding: EdgeInsets.only(left: 7, right: 7),
                      )
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}