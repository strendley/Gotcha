import 'package:flutter/material.dart';
import 'pi_settings.dart';
import 'household.dart';
import 'add_user.dart';
import 'features.dart';
import '../widget-camera/test.dart';
class AccountSettings extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: AccountSettingsPage(title: 'Account Settings'),
    );
  }
}

class AccountSettingsPage extends StatefulWidget {
  AccountSettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: new CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
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
                                onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettings())); },
                                title: new Text("Account Settings"),
                                leading: new Icon(Icons.account_circle, color:Colors.grey, size:25.0),
                                trailing: new Icon(Icons.arrow_forward_ios, color: Colors.grey, size:25.0),
                              ),
                            ),
                            new Divider(color:Colors.grey, indent:5.0),
                            new Container(
                              child: new ListTile(
                                onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => PiSettings())); },
                                title: new Text("Pi Settings"),
                                leading: new Icon(Icons.settings, color:Colors.grey, size:25.0),
                                trailing: new Icon(Icons.arrow_forward_ios, color:Colors.grey, size:25.0),
                              ),
                            ),
                            new Divider(color:Colors.grey, indent:5.0),
                            new Container(
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
                        )
                    ),

                    new Card(
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new ListTile(
                                onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => Household()));},
                                title: new Text("Manage Household"),
                                leading: new Icon(Icons.people, color:Colors.grey, size:25.0),
                                trailing: new Icon(Icons.arrow_forward_ios, color:Colors.grey, size:25.0),
                              ),
                            ),

                            new Divider(color:Colors.grey, indent:5.0),

                            new Container(
                              child: new ListTile(
                                onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser())); },
                                title: new Text("Add New User"),
                                leading: new Icon(Icons.person_add, color:Colors.grey, size:25.0),
                                trailing: new Icon(Icons.arrow_forward_ios, color:Colors.grey, size:25.0),
                              ),
                            ),

                            new Divider(color:Colors.grey, indent:5.0),

                            new Container(
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