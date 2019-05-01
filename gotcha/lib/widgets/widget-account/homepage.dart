import 'package:flutter/material.dart';
import 'pi_settings.dart';
import 'household.dart';
import 'add_user.dart';
import 'features.dart';
import '../widget-camera/test.dart';
import '../widget-account/widget-account.dart';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'package:flutter_vlc_player/vlc_player_controller.dart';

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
        primaryColor: Color(0xff314c66),
      ),
      home: HomePage(title: 'Gotcha'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final String urlToStreamVideo = 'http://192.168.0.16:8000/stream.mjpg';
  final VlcPlayerController controller = VlcPlayerController();
  final int playerWidth = 640;
  final int playerHeight = 360;

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
                background:  Container(
                  margin: EdgeInsets.all(30),
                  
                  decoration: BoxDecoration(
                    borderRadius:  new BorderRadius.circular(40),
                  ),
                  child: VlcPlayer(
                    defaultWidth: playerWidth,
                    defaultHeight: playerHeight,
                    url: urlToStreamVideo,
                    controller: controller,
                    placeholder: Center(child: Image.asset('gotcha.png')),
                  ), 
                ),
                centerTitle:true,
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
                              onTap:() { Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(email: widget.email))); },
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
                              title: new Text("About"),
                              leading: new Icon(Icons.favorite_border, color:Colors.grey, size:25.0),
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
