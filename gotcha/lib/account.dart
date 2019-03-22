import 'package:flutter/material.dart';
import 'main.dart';
//void main() => runApp(MyApp());

class AccountPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
          primaryColor: Colors.blue
        //primaryColor: Color(0xffECEAD3)
      ),
      home: Account(title: 'Account Settings'),
    );
  }
}

class Account extends StatefulWidget {
  Account({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<Account> {
  bool enablePush = false;
  bool openDoor = false;
  bool selfDestruct = false;

  String userName = "firstName lastName";
  String emailAddress = "example@gmail.com";
  String address = "1234 Example Street";

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();

  void onChangedSwitch(bool value) => setState(() => enablePush = value);
  void onChangedDoor(bool value) => setState(() => openDoor = value);
  void onChangedDestruct(bool value) => setState(() => selfDestruct = value);

  void onNameChange(String user) { if(user != "") setState(() => userName = user);}
  void onEmailChange(String email) { if(email != "") setState(() => emailAddress = email);}
  void onAddressChange(String addr) { if(addr != "") setState(() => address = addr);}

  @override
  void dispose()
  {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: new CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            new SliverAppBar(
              leading: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);}),
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                title: new Text("Account Settings"),
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      height: 100.0,
                      alignment: Alignment.center,
                      margin: new EdgeInsets.only(top: 35.0),
                      //color: Colors.red,
                      child: new CircleAvatar(
                        maxRadius: 45.0,
                        backgroundImage: AssetImage('user-placeholder.png'),
                      ),
                    ),
                    const Text("User", style: TextStyle(fontSize: 20.0, color: Colors.white), textAlign: TextAlign.center,),
                  ],
                ),
                centerTitle: true,
              ),
              backgroundColor: Colors.blue,
              pinned: true,
              floating: false,
              actions: <Widget>[
                new IconButton(
                  icon: Image.asset("gotcha.png"),
                  onPressed: () {
                    /* ... */
                  },
                ),
              ],
            ),
            SliverFillRemaining(
                child: new ListView(

                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left:10),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Text("Profile", style: TextStyle(fontSize: 20),),
                      ),
                    ),

                    new Card(
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                      //color: Colors.amber[50],
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              //color: Colors.red[100],
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
                                      new FlatButton(onPressed:() {onNameChange(nameController.text); Navigator.of(context).pop();}, child: new Text("OK"))
                                    ],
                                  )
                                  );
                                },
                                title: new Text(userName),
                                leading: new Icon(Icons.account_circle, color:Colors.grey, size:25.0),
                                trailing: new Icon(Icons.edit, color: Colors.grey, size:25.0),
                              ),
                            ),
                            new Divider(color:Colors.grey, indent:5.0),
                            new Container(
                              //color: Colors.blue[100],
                              child: new ListTile(
                                onTap:() {
                                  showDialog(
                                      context: context, child:
                                  AlertDialog(
                                    title: new Text("Email: "),
                                    content: new TextField(
                                        decoration: InputDecoration(
                                          hintText: emailAddress,
                                        ),
                                      controller: emailController,
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(onPressed:() {onEmailChange(emailController.text); Navigator.of(context).pop();}, child: new Text("OK"))
                                    ],
                                  )
                                  );
                                },
                                title: new Text(emailAddress),
                                leading: new Icon(Icons.email, color:Colors.grey, size:25.0),
                                trailing: new Icon(Icons.edit, color:Colors.grey, size:25.0),
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
                                      actions: <Widget>[
                                        new FlatButton(onPressed:() {  onAddressChange(addressController.text); Navigator.of(context).pop();}, child: new Text("OK"))
                                      ],
                                    )
                                    );
                                  },
                                  title: new Text(address),
                                  leading: new Icon(Icons.home, color:Colors.grey, size:25.0),
                                  trailing: new Icon(Icons.edit, color:Colors.grey, size:25.0),
                                )
                            )
                          ],
                        )

                    ),

                    Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 20.0),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("General Settings", style: TextStyle(fontSize: 20)))
                    ),

                    new Card(
                      //color: Colors.amber[50],
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              //color: Colors.red[100],
                              child: new ListTile(
                                  title: new Text("Door Status: <UNLOCKED> "),
                                  leading: new Icon(Icons.lock_outline, color:Colors.grey, size:25.0),
                                  trailing: new Switch(value: openDoor, onChanged: onChangedDoor, activeColor: Colors.blue[700],)
                              ),
                            ),

                            new Divider(color:Colors.grey, indent:5.0),

                            new Container(
                              //color: Colors.blue[100],
                              child: new ListTile(
                                  title: new Text("Push Notifications"),
                                  leading: new Icon(Icons.notifications, color:Colors.grey, size:25.0),
                                  trailing: new Switch(value: enablePush, onChanged: onChangedSwitch, activeColor:Colors.blue[700])
                              ),
                            ),

                            new Divider(color:Colors.grey, indent:5.0),

                            new Container(
                              //color: Colors.green[100],
                              child: new ListTile(
                                  title: new Text("Self Destruct"),
                                  leading: new Icon(Icons.alarm, color:Colors.grey, size:25.0),
                                  trailing: new Switch(value: selfDestruct, onChanged: onChangedDestruct, activeColor:Colors.blue[700])
                              ),
                            )
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