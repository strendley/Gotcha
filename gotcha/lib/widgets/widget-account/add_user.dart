import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart';

import '../widget-camera/test_pictures.dart';

class AddUser extends StatefulWidget {
  AddUser({Key key, this.email}) : super(key: key);
  final String email;

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser>{
  var _first_name = new TextEditingController();
  var _middle_name = new TextEditingController();
  var _last_name = new TextEditingController();
  var _resident_status = new TextEditingController();
  var _unlock_status = new TextEditingController();
  var _notify_me = new TextEditingController();
  Color _primaryColor = Color(0xffFFF0D1);
  
  int _residentRadioValue = -1;
  int _notifyRadioValue = -1;
  int _unlockRadioValue = -1;
  var _email;

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

  void _addRefToAccount(email, userRef) async {
    Map<String, String> data = <String, String>{
      "users" : userRef,
    };
    
    final DocumentReference dr = Firestore.instance
                                          .collection('accounts')
                                          .document(email);

    // create a document snap shot that we can modify and save to
    await  Firestore.instance
                    .collection('accounts')
                    .document(email)
                    .collection('users')
                    .add(data);
  }

  // function for creating a new user document
  void _add() {
    // hopefully email is not null
    _email = widget.email;
    print("email: ${widget.email}");

    // store the information about a user
    String document_name =  _first_name.text + "-" + 
                            _middle_name.text + "-" +
                            _last_name.text;

    // This is a document reference object that we have create to emulate
    // an active user
    final DocumentReference documentReference = Firestore.instance
                                                         .collection('users')
                                                         .document(document_name);
    
    // Create a new document for a user
    Map<String, String> data = <String, String>{
      "name_first" : _first_name.text,
      "name_middle": _middle_name.text,
      "name_last": _last_name.text,
      "notify": _notify_me.text,
      "resident_status": _resident_status.text,
      "unlock_option" : _unlock_status.text
    };
    
    // Saving data to firebase
    documentReference.setData(data).whenComplete(() async{
      _addRefToAccount(_email, document_name);
      print("Document Added");
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
                  new Expanded(
                      child: Padding(
                        child: RaisedButton(
                          color: _primaryColor,
                          child: Text("Continue", style: new TextStyle(fontSize: 20),),
                          onPressed: () { 
                            _add();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Pictures(text:"face_" + _first_name.text + _last_name.text+ '.jpg')));
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