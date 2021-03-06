import 'package:flutter/material.dart';
import 'package:googleapis/pubsub//v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:gotcha/creds.dart'; 
import 'package:gotcha/crud.dart';
import 'homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase-firestore-accounts.dart';
import 'dart:async';
import '../../data/model/account.dart';
const _SCOPES = const [PubsubApi.PubsubScope];

class AccountPage extends StatefulWidget {
  AccountPage({Key key, this.title, this.email}) : super(key: key);
  final String email;
  final String title;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();

    accounts = new List();
    documentRef = Firestore.instance.collection('accounts').document(widget.email);
    documentRef.get().then((data){
      accountSub?.cancel();
      accountSub = db.getNoteList().listen((QuerySnapshot snapshot) {
        final List<Account> accounts = snapshot.documents
            .map((documentSnapshot) => Account.fromMap(documentSnapshot.data))
            .toList();

        setState(() {
          this.accounts = accounts;
          nameController.text = data['name_first'] + " " + data['name_middle'] + " " + data['name_last'];
          phoneController.text = data['phone_number'];
          addressController.text = data["address_city"] + " " + data["address_state"];
        });
      });

    });

  }

  bool enablePush = false;
  bool openDoor = false;

  String userName = "Name";
  String phoneNumber = "Phone Number";
  String address = "Address";

  bool piLocked = true;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();


  List<Account> accounts;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> accountSub;
  DocumentReference documentRef;


  void onChangedSwitch(bool value) => setState(() => enablePush = value);
  void onChangedDoor(bool value) => setState(() => openDoor = value);

  void onNameChange(String user) { if(user != "") setState(() => userName = user);}
  void onPhoneChange(String phone) { if(phone != "") setState(() => phoneNumber = phone);}
  void onAddressChange(String addr) { if(addr != "") setState(() => address = addr);}


  // Publishes a message to open the door, pi will pull from subscription
  void publishTopic(topic){
    debugPrint("Publishing a message to a topic");

    final _credentials = returnJson();
  
    clientViaServiceAccount(_credentials, _SCOPES)
        .then((http_client) {
      var pubSubClient = new PubsubApi(http_client);
      var messages = {
        'messages': [
          {
            'data': base64Encode(utf8.encode('{"door": "unlock"}')),
          },
        ]
      };

      pubSubClient.projects.topics
          .publish(new PublishRequest.fromJson(messages), "projects/gotcha-233622/topics/$topic")
          .then((publishResponse) {
        debugPrint(publishResponse.toString());
      }).catchError((e,m){
        debugPrint(e.toString());
      });
    }); // clientViaServiceAccount

  }

  // This will update the data within the specified collection & document in firestore
  void updateData(collection, document, data){

    CrudMethods crudObj = new CrudMethods();

    crudObj.updateData(collection, document, {
      'locked': data
    }).then((result) {
      // dialogTrigger(context);
    }).catchError((e) {
      print(e);
    });

  }


  @override
  void dispose()
  {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff314C66),
        body: new CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            new SliverAppBar(
                leading: new IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white,),
                onPressed: () {
                  Navigator.pop(context);
                }),expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                title: new Text("Account Settings",
                style: new TextStyle(
                  color: Colors.white,
                  ),
                ),
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      height: 120.0,
                      alignment: Alignment.center,
                      margin: new EdgeInsets.only(top: 40.0),
                      child: new CircleAvatar(
                        maxRadius: 60.0,
                        backgroundImage: AssetImage('defaultUser.png'),
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
              backgroundColor: Color(0xff314C66),
              pinned: true,
              floating: false,
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
            SliverFillRemaining(
                child: new ListView(
                  children: <Widget>[
                    new Card(
                          child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new ListTile(
                                onTap:() {
                                  showDialog(
                                      context: context, child:
                                  AlertDialog(
                                    title: new Text("Name: "),
                                    content: new TextField(
                                      decoration: InputDecoration(
                                        hintText: userName,
                                      ),
                                      controller: nameController,
                                    ),

                                    actions: <Widget>[
                                      new FlatButton(onPressed:() {onNameChange(nameController.text); Navigator.of(context, rootNavigator: true).pop('dialog');}, child: new Text("OK"))
                                    ],
                                  )
                                  );
                                },
                                title: new Text(nameController.text),
                                leading: new Icon(Icons.account_circle, color:Colors.grey, size:25.0),
                                trailing: new Icon(Icons.edit, color: Colors.grey, size:25.0),
                              ),
                            ),
                            new Divider(color:Colors.grey, indent:5.0),
                            new Container(
                              child: new ListTile(
                                title: new Text(phoneController.text),
                                leading: new Icon(Icons.phone_iphone, color:Colors.grey, size:25.0),
                                trailing: new Icon(Icons.edit, color:Colors.grey, size:25.0),
                                
                                onTap:() {
                                  showDialog(
                                      context: context, child:
                                  AlertDialog(
                                    title: new Text("Phone Number: "),
                                    content: new TextField(
                                        decoration: InputDecoration(
                                          hintText: phoneNumber,
                                        ),
                                      controller: phoneController,
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(onPressed:() {onPhoneChange(phoneController.text); Navigator.of(context, rootNavigator: true).pop('dialog');}, child: new Text("OK"))
                                    ],
                                  )
                                  );
                                },
                              ),
                            ),
                            new Divider(color:Colors.grey, indent:5.0),
                            new Container(
                              //color: Colors.green[100],
                                child: new ListTile(
                                  onTap:() {
                                    showDialog(
                                        context: context, child:
                                    AlertDialog(
                                      title: new Text("Address: "),
                                      content: new TextField(
                                          decoration: InputDecoration(
                                            hintText: address,
                                          ),
                                        controller: addressController,
                                      ),
                                      actions: <Widget>[              // here for testing, TODO: Assign to first switch on this page // updateData('pi_config_states','door', true)
                                        new FlatButton(onPressed:() { onAddressChange(addressController.text); Navigator.of(context, rootNavigator: true).pop('dialog');}, child: new Text("OK"))
                                      ],
                                    )
                                    );
                                  },
                                  title: new Text(addressController.text),
                                  leading: new Icon(Icons.home, color:Colors.grey, size:25.0),
                                  trailing: new Icon(Icons.edit, color:Colors.grey, size:25.0),
                                )
                            )
                          ],
                        )

                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    
                    new Card(
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new ListTile(
                                  title: new Text("Door Status"),
                                  leading: openDoor==true?new Icon(Icons.lock_open, color:Colors.grey, size:25.0):
                                                          new Icon(Icons.lock, color:Colors.grey, size:25.0),
                                  trailing: new Switch(value: openDoor, onChanged: onChangedDoor, activeColor: Colors.blue[700],)
                              ),
                            ),

                            new Divider(color:Colors.grey, indent:5.0),

                            new Container(
                              child: new ListTile(
                                  title: new Text("Push Notifications"),
                                  leading: enablePush==true?new Icon(Icons.notifications_active, color:Colors.grey, size:25.0):
                                                            new Icon(Icons.notifications_off, color:Colors.grey, size:25.0),
                                  trailing: new Switch(value: enablePush, onChanged: onChangedSwitch, activeColor:Colors.blue[700])
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                )
            )
          ],
        )
    );
  }
}
