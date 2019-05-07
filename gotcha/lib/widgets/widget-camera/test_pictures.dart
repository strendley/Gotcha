import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gotcha/widgets/widget-account/homepage.dart';

class Pictures extends StatefulWidget {
  Pictures({Key key, this.title, @required this.text}) : super(key: key);
  final text;
  final String title;
  @override
  _PicturePageState createState() => _PicturePageState();
}


class _PicturePageState extends State<Pictures> {
  Color _primaryColor = Color(0xff314C66);
  Color _secondaryColor = Color(0xffFFF0D1);

  File _image;
  var image;
  Future getImageFromCam() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;    });
  }

  Future getImageFromGallery() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      _image = image;
    });
  }


  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: _primaryColor,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: new Container(
          alignment: Alignment.center,
          child: Text('Add User Photo',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: _primaryColor,
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
      body: Column(
        children: <Widget> [
          new Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: const Align(
                  alignment: Alignment.topCenter,
                  child: Text("Gotcha", 
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  )))
          ),

          new Row(

            children: <Widget>[
              new Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(
                      color: _secondaryColor,
                      child: Text("+  Gallery", 
                      style: new TextStyle(fontSize: 20),),
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

          SizedBox(height: 20,),

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

          SizedBox(height: 20,),

          new Row(
          children: <Widget>[
            new Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    color: _secondaryColor,
                    child: Text("Back", style: new TextStyle(fontSize: 20),),
                    onPressed: () {Navigator.pop(context);},
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
                    child: Text("Done", style: new TextStyle(fontSize: 20),),
                    onPressed: () {//Add new user to database
                      Navigator.pop(context);
                      Navigator.pop(context);
                      var _name = widget.text;
                      FirebaseStorage _storage = FirebaseStorage.instance;
                      StorageReference ref =  _storage.ref().child(_name);
                      StorageUploadTask uploadTask = ref.putFile(image);},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)
                    ),
                  ),
                  //padding: EdgeInsets.only(left: 10, right: 10),
                )
            ),
            ],
          ),


        ],
      ),
    );
  }
}
