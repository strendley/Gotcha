import 'package:flutter/material.dart';
import 'package:googleapis/pubsub//v1.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'dart:async' show Future;
import '../widget-account/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _SCOPES = const [PubsubApi.PubsubScope];

//void main() => runApp(MyApp());

class TestCameraPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestCamera(title: 'Test Pictures Page'),
    );
  }
}

class TestCamera extends StatefulWidget {
  TestCamera({Key key, this.title}) : super(key: key);
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
  bool testPic(){
    var result = false;
    final DocumentReference documentReference = Firestore.instance.collection('pi_config_states').document('image_test');
    Map<String, bool> data = <String, bool>{
      "toTest" : true,
      "testResult": false,
      "hasTested": false
    };
    documentReference.setData(data);

    var gotResult = false;
    while(!gotResult)
      {
        var dataStuff = documentReference.get();
        print(dataStuff.toString());
        print('hi');
        gotResult = true;
      }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Pictures',
      theme: ThemeData(
        primaryColor: Color(0xff314c66),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: new IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: () {Navigator.pop(context);}),
          title: Text('Test Pictures'),
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
        body: Center(
          child: Column(
            children: <Widget>[

              SizedBox(height: 10),

              new Row(

                children: <Widget>[
                  new Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          color: Color(0xffFFF0D1),
                          child: Text("+  Gallery", style: new TextStyle(fontSize: 20),),
                          onPressed: () {getImageFromGallery();},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)
                          ),
                        ),
                        //padding: EdgeInsets.only(left: 10, right: 10),
                      )
                  ),
                  new Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          color: Color(0xffFFF0D1),
                          child: Text("+  Camera", style: new TextStyle(fontSize: 20),),
                          onPressed: () {getImageFromCam();},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                        //padding: EdgeInsets.only(left: 10, right: 10),
                      )
                  ),
                ],
              ),

              new Padding(
                padding: EdgeInsets.only(top:5.0),
                child: new Align(
                  alignment: Alignment.topCenter,
                //child: new Text('click the image to crop', style: new TextStyle(fontSize: 15),)
                ),
              ),

              new Column(
                children: <Widget>[
                  new Container(
                    alignment: Alignment.center,
                    child: _image == null? new Image.asset('defaultUser.png', height: 250, width: 250):
                                           new Image.file(_image, height: 250, width: 250,),
                    height: 265.0,
                    width: 260.0,
                      decoration: new BoxDecoration(
                        color: const Color(0xFF314c66), // border color
                        shape: BoxShape.rectangle,
                      )
                  ),
                ],
              ),

              new Padding(
                  padding: EdgeInsets.only(top:15.0),
              ),

              new Column(
                children: <Widget>[
                  //new Expanded(
                    //child: Padding(
                SizedBox(
                    height: 60,
                      width: 160,
                      child: RaisedButton(
                        color: Color(0xffFFF0D1),
                        child: Text("Test Picture!", style: new TextStyle(fontSize: 20),),
                        onPressed: () {
                          // get prediction here
                          var result = testPic();

                          showDialog(
                              context: context, child:
                              AlertDialog(
                              title: new Text("Prediction score of: "),
                          actions: <Widget>[
                          //new FlatButton(onPressed:() {}, child: new Text("Yes")),
                          new FlatButton(onPressed:() {Navigator.of(context).pop();}, child: new Text("Okay")),
                          ],
                          ),
                          ); // showDialog()
                        }, // onPressed:
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)
                        ),
                      ),
                      //padding: EdgeInsets.only(left: 7, right: 7),
                    ),
                  ],
              ),

              new Padding(
                padding: EdgeInsets.only(top:30.0),
                    child: new Text('Results: ', style: new TextStyle(fontSize: 25),)
              ),

              new Padding(
                  padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                  child: new Text('<RESULT OF TEST>', style: new TextStyle(fontSize: 25, color: Colors.red),)
                //),
              ),
/*
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
              */
            ],
          )
        ),
      ),
    );
  }
}
