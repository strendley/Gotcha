import 'package:flutter/material.dart';
import 'dart:io';

import 'display_selected_file.dart';

//Build body
Widget buildBody(File _file) {
  return new Container(
    child: new Column(
      children: <Widget>[displaySelectedFile(_file),],
    ),
  );
}