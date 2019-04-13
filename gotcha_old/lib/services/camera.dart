// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:async';
// import 'dart:io';

// abstract class BaseCamera {
//   Future<String> getImageFromCam();
//   Future<String> getImageFromGallery();
// }

// class Camera implements BaseCamera {
//   final File _image;

//   Future getImageFromCam() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.camera);
//     setState(() {
//       _image = image;    
//     });
//   }

//   Future getImageFromGallery() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = image;
//     });
//   }

// }
