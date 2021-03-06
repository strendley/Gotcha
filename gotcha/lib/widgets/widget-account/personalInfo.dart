import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firebase-firestore-users.dart';
import '../../data/model/user.dart';
import 'homepage.dart';

class PersonalInfo extends StatefulWidget {
  PersonalInfo({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

  @override
  _PersonalInfo createState() => _PersonalInfo();
}

class _PersonalInfo extends State<PersonalInfo> {
  var firstName = new TextEditingController();
  var middleName = new TextEditingController();
  var lastName = new TextEditingController();
  var addressCity = new TextEditingController();
  var addressState = new TextEditingController();
  var addressStreet = new TextEditingController();
  var addressZip = new TextEditingController();
  var phoneNumber = new TextEditingController();
  var country = new TextEditingController();
  Color _primaryColor = Color(0xff314C66);
  Color _secondaryColor =  Color(0xffFFF0D1);
  Color _fillColor = Color(0xfffffffff);
  Color _textColor = Colors.white;
  List<User> users;
  FirebaseFirestoreService db = new FirebaseFirestoreService();
  
  StreamSubscription<QuerySnapshot> userSub;

  void _add() {
    String document_name = widget.email;
    final DocumentReference documentReference = Firestore.instance.collection('accounts').document(document_name);
    Map<String, String> data = <String, String>{
      "name_first" : firstName.text,
      "name_middle": middleName.text,
      "name_last": lastName.text,
      "address_city": addressCity.text,
      "address_state": addressState.text,
      "address_zip" : addressZip.text,
      "phone_number": phoneNumber.text,
      "country": country.text,
    };

    documentReference.setData(data).whenComplete(() async{
      print("Document Added");
    }).catchError((e)=> print(e));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: _primaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Gotcha'),
          actions: <Widget>[
            new IconButton(
              icon: Image.asset("gotcha.png"),
              onPressed: () {

              },
            ),
          ],

        ),

        body: Container(
          color: _primaryColor,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    Text(
                      'Create Account',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: _textColor, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                new Row(
                  children: <Widget>[
                    Text(
                      'First Name',
                      textAlign: TextAlign.left,
                      style: TextStyle(color:_textColor, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: firstName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white, filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Middle Name',
                      textAlign: TextAlign.left,
                      style: TextStyle(color:_textColor, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: middleName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: _fillColor, filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Last Name',
                      textAlign: TextAlign.left,
                      style: TextStyle(color:_textColor, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: lastName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: _fillColor, filled: true,
                  ),
                ),

                SizedBox(height: 10),

                Divider(
                  color:_textColor,

                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Street Address',
                      textAlign: TextAlign.left,
                      style: TextStyle(color:_textColor, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: addressStreet,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: _fillColor, filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'City',
                      textAlign: TextAlign.left,
                      style: TextStyle(color:_textColor, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: addressCity,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: _fillColor, filled: true,
                  ),
                ),

                SizedBox(height: 10),
                
                new Row(
                  children: <Widget>[
                    Text(
                      'Zipcode',
                      textAlign: TextAlign.left,
                      style: TextStyle(color:_textColor, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: addressZip,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: _fillColor, filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Country',
                      textAlign: TextAlign.left,
                      style: TextStyle(color:_textColor, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: country,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: _fillColor, filled: true,
                  ),
                ),

                SizedBox(height: 10),

                Divider(
                  color:_textColor,

                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Phone number',
                      textAlign: TextAlign.left,
                      style: TextStyle(color:_textColor, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: phoneNumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: _fillColor, filled: true,
                  ),
                ),

                SizedBox(height: 50),

                SizedBox(
                  width: 125,
                  height: 60,
                  child: RaisedButton(
                    color: Color(0xffFFF0D1),
                    onPressed: () =>{
                        _add(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => HomePage(email: widget.email),),
                        )
                    },
                    child: const Text('Finish', style: TextStyle(fontSize: 20)),
                  ),
                ),

                SizedBox(height: 100),

              ],
            ),
          ),

        ),
      ),
    );
  }

}