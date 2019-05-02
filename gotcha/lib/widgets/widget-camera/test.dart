import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/pubsub//v1.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:gotcha/creds.dart';
import '../widget-account/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

const _SCOPES = const [PubsubApi.PubsubScope];

//void main() => runApp(MyApp());

class TestCameraPage extends StatelessWidget {
  TestCameraPage({Key key, this.email}):super(key:key);

  final String email;
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
  TestCamera({Key key, this.title, this.email}) : super(key: key);
  final String title;
  final String email;
  @override
  _TestCameraState createState() => _TestCameraState();


}

class _TestCameraState extends State<TestCamera> {
  File _image;
  Color _primaryColor = Color(0xff314C66);
  Color _secondaryColor = Color(0xffFFF0D1);

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
  void uploadTest(){
    FirebaseStorage _storage = FirebaseStorage.instance;
    StorageReference ref =  _storage.ref().child("test.jpg");
    StorageUploadTask uploadTask = ref.putFile(_image);
  }


  Future<String> testPic() async{
    var result;
    final DocumentReference documentReference = Firestore.instance.collection('pi_config_states').document('image_test');
    publishTopic("pi_configuration");
    var info;
    var hasTested = false;

    while (!hasTested){
      info = await documentReference.get().then((docSnap) {
        print(docSnap['hasTested']);
        if (docSnap['hasTested'] == 'true')
          {
            print('madeIt');
            hasTested = true;
            return docSnap['testResult'];
          }

      });
    }
    result = info;
    Map<String, String> dataEnd = <String, String>{
      "testResult": 'unknown',
      "hasTested":  'false'
    };
    documentReference.setData(dataEnd);
    return result;
  }
  final TextEditingController c1 = new TextEditingController();

  void publishTopic(topic){
    debugPrint("Publishing a message to a topic");

    //debugPrint(_SCOPES[0]);
    final _credentials = returnJson();
    //debugPrint(json_string);
    clientViaServiceAccount(_credentials, _SCOPES)
        .then((http_client) {
      var pubSubClient = new PubsubApi(http_client);
      var messages = {
        'messages': [
          {
            'data': base64Encode(utf8.encode('{"tmp_picture": "test"}')),
          },
        ]
      };

      pubSubClient.projects.topics
          .publish(new PublishRequest.fromJson(messages), "projects/gotcha-233622/topics/$topic")
          .then((publishResponse) {
        debugPrint(publishResponse.toString());
      }).catchError((e,m){
        debugPrint(e.toString());
      });
    }); // clientViaServiceAccount

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Pictures',
      theme: ThemeData(
        primaryColor:_primaryColor,
      ),
      home: Scaffold(
        backgroundColor: _primaryColor,
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
                  MaterialPageRoute(builder: (BuildContext context) => Home(email:widget.email),),
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
                          color: _secondaryColor,
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
                          color: _secondaryColor,
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
                        color: _secondaryColor, // border color
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
                        onPressed: () async {
                          // get prediction here
                          uploadTest();
                          var result = await testPic();

                          print('*************');
                          setState((){ c1.text = result;
                          }); // onPressed:
                        },
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
                    child: new Text('Results: ', 
                    style: new TextStyle(
                      fontSize: 25,
                      color: Colors.white),)
              ),
              new Padding(
              padding: EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new Text(c1.text, style: new TextStyle(fontSize:20, color:Colors.red))
              ,)
            ],
          )
        ),
      ),
    );
  }
}
