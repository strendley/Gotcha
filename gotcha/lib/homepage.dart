import 'package:flutter/material.dart';
import 'account.dart';
import 'test_pictures.dart';
import 'pi_settings.dart';
import 'household.dart';
import 'add_user.dart';
import 'test.dart';
import 'features.dart';

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
        primaryColor: Colors.blue
        //primaryColor: Color(0xffECEAD3)
      ),
      home: MyHomePage(title: 'Account Settings'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: new CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            new SliverAppBar(
              //leading: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {/* ... */}),
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
               // title: Image.asset('gotcha.png'),
                background: Image.network(
                  "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                  fit: BoxFit.cover,

                ),
                centerTitle: true,
              ),
              pinned: true,
              floating: false,
            ),
            SliverFillRemaining(
              child: new ListView(
                children: <Widget>[
                  new Card(
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            child: new ListTile(
                              onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => Account())); },
                              title: new Text("Account Settings"),
                              leading: new Icon(Icons.account_circle, color:Colors.grey, size:25.0),
                              trailing: new Icon(Icons.arrow_forward_ios, color: Colors.grey, size:25.0),
                            ),
                          ),
                          new Divider(color:Colors.grey, indent:5.0),
                          new Container(
                            //color: Colors.blue[100],
                            child: new ListTile(
                              onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => PiSettings())); },
                              title: new Text("Pi Settings"),
                              leading: new Icon(Icons.settings, color:Colors.grey, size:25.0),
                              trailing: new Icon(Icons.arrow_forward_ios, color:Colors.grey, size:25.0),
                            ),
                          ),
                          new Divider(color:Colors.grey, indent:5.0),
                          new Container(
                            //color: Colors.green[100],
                              child: new ListTile(
                                onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => TestCamera())); },
                                title: new Text("Test Camera"),
                                leading: new Icon(Icons.linked_camera, color:Colors.grey, size:25.0),
                                trailing: new Icon(Icons.arrow_forward_ios, color:Colors.grey, size:25.0),
                              )
                          )
                        ],
                      )

                  ),

                  Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                      child: const Align(
                          alignment: Alignment.centerLeft,
                          //child: Text("General Settings", style: TextStyle(fontSize: 20))
                      )
                  ),

                  new Card(
                    //color: Colors.amber[50],
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            //color: Colors.red[100],
                            child: new ListTile(
                              onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => Household()));},
                              title: new Text("Manage Household"),
                              leading: new Icon(Icons.people, color:Colors.grey, size:25.0),
                              trailing: new Icon(Icons.arrow_forward_ios, color:Colors.grey, size:25.0),
                            ),
                          ),

                          new Divider(color:Colors.grey, indent:5.0),

                          new Container(
                            //color: Colors.blue[100],
                            child: new ListTile(
                              onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser())); },
                              title: new Text("Add New User"),
                              leading: new Icon(Icons.person_add, color:Colors.grey, size:25.0),
                              trailing: new Icon(Icons.arrow_forward_ios, color:Colors.grey, size:25.0),
                            ),
                          ),

                          new Divider(color:Colors.grey, indent:5.0),

                          new Container(
                            //color: Colors.green[100],
                            child: new ListTile(
                              onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => Features()));},
                              title: new Text("More Features"),
                              leading: new Icon(Icons.vpn_lock, color:Colors.grey, size:25.0),
                              trailing: new Icon(Icons.arrow_forward_ios, color:Colors.grey, size:25.0),
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
