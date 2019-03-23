import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Pictures extends StatefulWidget {
  Pictures({Key key, this.title}) : super(key: key);

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
                        );
                    }),
                  ),
              )
            ),

            new Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text("Click on image to crop or remove it", style: TextStyle(fontSize: 15))
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
