import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'main.dart';

class PicturesPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
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
          primaryColor: Colors.blue
        //primaryColor: Color(0xffECEAD3)
      ),
      home: Pictures(title: 'Picture Test'),
    );
  }
}

class Pictures extends StatefulWidget {
  Pictures({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<Pictures> {
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
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add User Pictures'),
        centerTitle: true,
      ),
      body: Column(
          children: <Widget> [
            new Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: const Align(
                    alignment: Alignment.topCenter,
                    child: Text("Please Add 8 User Photos", style: TextStyle(fontSize: 25)))
            ),

            ButtonTheme(
              buttonColor: Theme.of(context).buttonColor,
              minWidth: double.infinity,
            child: RaisedButton(
              onPressed: () {getImageFromGallery();},
              child: Text('Add Old Pictures From Gallery'),
                ),
            ),

            ButtonTheme(
              buttonColor: Theme.of(context).buttonColor,
              minWidth: double.infinity,
              child: RaisedButton(
                onPressed: () {getImageFromCam();},
                child: Text('Add New Pictures From Camera'),
              ),
            ),

            new Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: const Align(
                    alignment: Alignment.topCenter,
                    child: Text("Percent Completion: ???", style: TextStyle(fontSize: 20)))
            ),
            Expanded(
              child: SafeArea(
                  child:
                    new GridView.count(
                      crossAxisCount: 4,
                      children: new List<Widget>.generate(8, (index) {
                        return new GridTile(
                          child: new FadeInImage(placeholder: AssetImage('user_placeholder.png'), image: AssetImage('furry_george.jpg'))//image: FileImage(_image))
                           // child: new Image.asset('user-placeholder.png')
                        );
                    }),
                  ),
              )
            ),

            new Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //child: const Align(
                    //alignment: Alignment.center,
                    child: Text("Click on image to crop or remove it", style: TextStyle(fontSize: 15))
                //)
            ),


            ButtonTheme(
              buttonColor: Theme.of(context).buttonColor,
              minWidth: double.infinity,
              child: RaisedButton(
                onPressed: () {Navigator.pop(context);},
                child: Text('Previous'),
              ),
            ),

            ButtonTheme(
              buttonColor: Theme.of(context).buttonColor,
              minWidth: double.infinity,
              child: RaisedButton(
                onPressed: () {},
                child: Text('Finish'),
              ),
            ),


        ],
      ),
    );
  }
}
