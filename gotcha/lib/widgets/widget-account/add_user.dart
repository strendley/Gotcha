import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'homepage.dart';

import '../widget-camera/test_pictures.dart';

class AddUser extends StatefulWidget {
  AddUser({Key key, this.email}) : super(key: key);
  final String email;

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser>{
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var _first_name = new TextEditingController();
  var _middle_name = new TextEditingController();
  var _last_name = new TextEditingController();
  var _resident_status = new TextEditingController();
  var _unlock_status = new TextEditingController();
  var _notify_me = new TextEditingController();
  
  int _residentRadioValue = -1;
  int _notifyRadioValue = -1;
  int _unlockRadioValue = -1;

  void _setResidentStatus(int value) {

    setState(() {
      _residentRadioValue = value;

      switch(_residentRadioValue){
        case 0:
          _resident_status.text = "resident";
          break;
        case 1:
          _resident_status.text = "guest";
          break;
        case 2:
          _resident_status.text = "unwelcomed";
          break;
      }
    });
  }

  void _setNofifyStatus(int value){
    setState(() {
      _notifyRadioValue = value; 

      switch(_notifyRadioValue){
        case 0:
          _notify_me.text = "true";
          break;
        case 1:
          _notify_me.text = "false";
          break;
      }
    });
  }

  void _setUnlockStatus(int value) {
    setState(() {
      _unlockRadioValue = value; 

      switch(_unlockRadioValue){
        case 0:
          _unlock_status.text = "true";
          break;
        case 1:
          _unlock_status.text = "false";
          break;
      }
    });
  }

  void _add() {
    final DocumentReference documentReference = Firestore.instance.collection('users').document(_first_name.text+"/"+_middle_name.text+"/"+_last_name.text);
    Map<String, String> data = <String, String>{
      "name_first" : _first_name.text,
      "name_middle": _middle_name.text,
      "name_last": _last_name.text,
      "notify": _notify_me.text,
      "resident_status": _resident_status.text,
      "unlock_option" : _unlock_status.text
    };

    documentReference.setData(data).whenComplete(() async{
      print("Document Added");
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.device}');
    }).catchError((e)=> print(e));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff314C66),
      ),
      title: 'Add New User',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: new IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: () {Navigator.pop(context);}),
          title: Text('Add New User'),
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
              new Padding(
                padding: EdgeInsets.only(left: 15, right: 20, top: 15),
                  child: TextFormField(
                    controller: _first_name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name:'
                    ),
                    style: new TextStyle(fontSize: 20),
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(left: 15, right: 20, top: 10),
                  child: TextFormField(
                    controller: _middle_name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Middle Name:'
                    ),
                    style: new TextStyle(fontSize: 20),
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 5),
                  child: TextFormField(
                    controller: _last_name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name:'
                    ),
                    style: new TextStyle(fontSize: 20),
                  )
              ),

              new Divider(color:Colors.black,),// indent:5.0),

              new Padding(
                  padding: EdgeInsets.only(left: 15, top: 4),
                child: new Align(
                  alignment: Alignment.topLeft,
                    child: new Text('Resident Status:', style: new TextStyle(fontSize: 22),)
                )
              ),

              new Padding(
                padding: EdgeInsets.only(top: 0),
               child: new Row(
                 children: <Widget>[
                   new Radio(
                     value: 0,
                     groupValue: _residentRadioValue,
                     onChanged: _setResidentStatus,
                   ),
                   new Text('Resident'),

                   new Radio(
                     value: 1,
                     groupValue: _residentRadioValue,
                     onChanged: _setResidentStatus,
                   ),
                   new Text('Guest'),

                   new Radio(
                     value: 2,
                     groupValue: _residentRadioValue,
                     onChanged: _setResidentStatus,
                   ),
                   new Text('Unwelcomed'),
                 ],
               )
              ),

              new Divider(color:Colors.black,),

              new Padding(
                  padding: EdgeInsets.only(left: 15, top: 4),
                  child: new Align(
                      alignment: Alignment.topLeft,
                      child: new Text('Door Unlock Options:', style: new TextStyle(fontSize: 22),)
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: new Row(
                    children: <Widget>[
                      new Radio(
                        value: 0,
                        groupValue: _unlockRadioValue,
                        onChanged: _setUnlockStatus,
                      ),
                      new Text('Always'),

                      new Radio(
                        value: 1,
                        groupValue: _unlockRadioValue,
                        onChanged: _setUnlockStatus,
                      ),
                      new Text('Ask Me First'),

                      new Radio(
                        value: 2,
                        groupValue: _unlockRadioValue,
                        onChanged: _setUnlockStatus,
                      ),
                      new Text('Never'),
                    ],
                  )
              ),

              new Divider(color:Colors.black,),

              new Padding(
                  padding: EdgeInsets.only(left: 15, top: 4),
                  child: new Align(
                      alignment: Alignment.topLeft,
                      child: new Text('Notify Me?', style: new TextStyle(fontSize: 22),)
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: new Row(
                    children: <Widget>[
                      new Radio(
                        value: 0,
                        groupValue: _notifyRadioValue,
                        onChanged: _setNofifyStatus,
                      ),
                      new Text('Yes'),

                      new Radio(
                        value: 1,
                        groupValue: _notifyRadioValue,
                        onChanged: _setNofifyStatus,
                      ),
                      new Text('No'),
                    ],
                  )
              ),

              new Row(
                children: <Widget>[
                  /*
                  new Expanded(
                      child: Padding(
                        child: RaisedButton(
                          color: Color(0xffFFF0D1),
                          child: Text("Menu", style: new TextStyle(fontSize: 20),),
                          onPressed: () => {
                            Navigator.of(context).pop()
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)
                          ),
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                      )
                  ),
                  */
                  new Expanded(
                      child: Padding(
                        child: RaisedButton(
                          color: Color(0xffFFF0D1),
                          child: Text("Continue", style: new TextStyle(fontSize: 20),),
                          onPressed: () { 
                            _add();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Pictures(text:_first_name.text + _last_name.text)));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                        padding: EdgeInsets.only(left: 50, right: 50),
                      )
                  ),
                ],
              ),

            ],
          )
        ),
      ),
    );
  }
}