import 'package:flutter/material.dart';
import 'dart:io';

Widget displaySelectedFile(File file) {
  return new SizedBox(
    width: 200.0,
    child: file == null
        ? new Center(
          child: Container(
            child: new Column(
              children: <Widget>[
                Icon(Icons.adb),
                Text('Take Photo')
              ]
            ),
          ),
        )
        : new Center(child:Image.file(file),),
  );
}