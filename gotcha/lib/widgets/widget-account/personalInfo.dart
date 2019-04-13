import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget-account/homepage.dart';
import '../widget-account/widget-account.dart';
import '../../services/firebase-firestore-users.dart';
import '../../data/model/user.dart';
import 'homepage.dart';

class PersonalInfo extends StatefulWidget {
  PersonalInfo({Key key, this.title}) : super(key: key);

  final String title;

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
  List<User> users;
  FirebaseFirestoreService db = new FirebaseFirestoreService();
  
  StreamSubscription<QuerySnapshot> userSub;
  
  @override
  void initState() {
    super.initState();
 
    users = new List();
 
    userSub?.cancel();
    userSub = db.getNoteList().listen((QuerySnapshot snapshot) {
      final List<User> users = snapshot.documents
          .map((documentSnapshot) => User.fromMap(documentSnapshot.data))
          .toList();
 
      setState(() {
        this.users = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff314C66),
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
          decoration: BoxDecoration(color: Colors.grey[100]),//(0xffD9E8FD)),
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
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                new Row(
                  children: <Widget>[
                    Text(
                      'First Name',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
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
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: middleName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Last Name',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: lastName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 10),

                Divider(
                  color: Colors.black,

                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Street Address',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: addressStreet,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'City',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: addressCity,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 10),
                
                new Row(
                  children: <Widget>[
                    Text(
                      'Zipcode',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: addressZip,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Country',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: country,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 10),

                Divider(
                  color: Colors.black,

                ),

                SizedBox(height: 10),

                new Row(
                  children: <Widget>[
                    Text(
                      'Phone number',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),

                TextField(
                  controller: phoneNumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Color(0xffffffff), filled: true,
                  ),
                ),

                SizedBox(height: 50),

                SizedBox(
                  width: 125,
                  height: 60,
                  child: RaisedButton(
                    color: Color(0xffFFF0D1),
                    onPressed: () =>{
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => Home(),),
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