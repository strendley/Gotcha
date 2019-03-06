import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'build_body.dart';

/*
* TODO: uncomment this block of code for making a connection with google
* cloud services.
*
* for futher assitance use this URL:
* https://cloud.google.com/vision/automl/docs/client-libraries
* and 
* https://developers.google.com/api-client-library/
*/
// final _credentials = new ServiceAccountCredentials.fromJson(r'''
// {
//   "private_key_id": ...,
//   "private_key": ...,
//   "client_email": ...,
//   "client_id": ...,
//   "type": "service_account"
// }
// ''');
// const _SCOPES = const [StorageApi.DevstorageReadOnlyScope];

void main() {
/*
* TODO: uncomment this block of code for making a connection with google
* cloud services.
*
* for futher assitance use these URL's:
* https://cloud.google.com/vision/automl/docs/client-libraries
* and 
* https://developers.google.com/api-client-library/
*/
//   clientViaServiceAccount(_credentials, _SCOPES).then((http_client) {
//     var storage = new StorageApi(http_client);
//     storage.buckets.list('dart-on-cloud').then((buckets) {
//       print("Received ${buckets.items.length} bucket names:");
//       for (var file in buckets.items) {
//         print(file.name);
//       }
//     });
//   });
  
 runApp(new MyApp()); 
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _file;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Recognition'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: new FloatingActionButton(
            tooltip: 'Take photo',
            onPressed: () async {
                try {
                  var file =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                } catch (e) {
                  print(e.toString());
                }
              },
            child:Icon(Icons.add_a_photo),
            elevation: 2.0,
        ),
        bottomNavigationBar:  BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(icon: new Icon(Icons.home), title: new Text('Home')),
            BottomNavigationBarItem(icon: new Icon(Icons.camera), title: new Text('Camera')),
            BottomNavigationBarItem(icon: new Icon(Icons.info), title: new Text('Info')),
          ],
        ),
        body: Center(child: Container( child : buildBody(_file),),),
        
      ),
    );
  }
}