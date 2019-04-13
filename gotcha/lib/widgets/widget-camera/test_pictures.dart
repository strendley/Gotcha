import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'view.dart';

class Pictures extends StatefulWidget {
  Pictures({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<Pictures> {
  List<Asset> images = List<Asset>();
  String _error;

  @override
  void initState() {
    super.initState();
  }
  Future<void> loadAssets() async {

    setState(() {
      print("Error potentially in setState().");
      images = List<Asset>();
      print("ERROR Not HERE!");
    });

    List<Asset> resultList;
    String error;

    try {
      print("trying to get images");
      resultList = await MultiImagePicker.pickImages(maxImages: 15);
      print("got images");
    } on PlatformException catch (e) {
      print("SUPER ERROR");
      error = e.message;
    }
    print("not sure what's happening");
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    print("is mounted");
    setState(() {
      print("images are being loaded");
      images = resultList;
      print("images loaded... Doesn't make sense");
      if (error == null) _error = 'No Error Dectected';
    });
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
                  child: Text("Please Add 10 User Photos", style: TextStyle(fontSize: 25)))
          ),

          ButtonTheme(
            buttonColor: Theme.of(context).buttonColor,
            minWidth: double.infinity,
            child: RaisedButton(
              onPressed: () {loadAssets();},
              child: Text('Add Old Pictures From Gallery'),
            ),
          ),

          ButtonTheme(
            buttonColor: Theme.of(context).buttonColor,
            minWidth: double.infinity,
            child: RaisedButton(
              onPressed: () {/*getImageFromCam();*/},
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
                  crossAxisCount: 5,
                  children: new List<Widget>.generate(images.length, (index) {
                    return AssetView(index, images[index]);
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
