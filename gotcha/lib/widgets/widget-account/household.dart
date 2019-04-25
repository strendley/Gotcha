import 'add_user.dart';
import 'package:flutter/material.dart';
import 'package:gotcha/data/mock/user.dart';

class UserRow extends StatefulWidget
{
  final User user;
  UserRow(this.user);

  @override
  _UserRowState createState() => _UserRowState(user);

}

class _UserRowState extends State<UserRow> {
  User user;
  bool isHome = false;

  void onChangedSwitch(bool value) => setState(() => isHome = value);

  _UserRowState(this.user);

  Widget get userThumbnail {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 10.0),
      alignment: FractionalOffset.centerLeft,
      child: new CircleAvatar(
        backgroundImage: AssetImage(user.image),
        maxRadius: 55,
      ),
        padding: const EdgeInsets.all(5.0), // borde width
    );
  }

  Widget get userCard {
    return new Container(
      height: 150.0,
      margin: new EdgeInsets.only(left: 0.0),
      decoration: new BoxDecoration(
        color: new Color(0xff314c66),
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0)
            )
          ]
      ),
    );
  }

  Widget get userContent {
    return new Container(
      margin: new EdgeInsets.fromLTRB(120.0, 0.0, 15.0, 5.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(user.name,
                    style: TextStyle(fontSize: 25, color: Colors.white),),
                  new IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white,),
                    onPressed: () {},
                  ),
                ],
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(user.residentStatus + '\n' + user.unlockOptions,
                    style: TextStyle(fontSize: 18, color: Colors.white),),
                  new Container(
                    alignment: Alignment.bottomRight,
                    child: new IconButton(
                      icon: const Icon(
                          Icons.delete_forever, color: Colors.white),
                      onPressed: () {
                        showDialog(
                            context: context, child:
                            AlertDialog(
                            title: new Text("Really Delete User? "),
                        actions: <Widget>[
                        new FlatButton(onPressed:() {}, child: new Text("Yes")),
                        new FlatButton(onPressed:() {}, child: new Text("No")),
                        ],
                        ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Text("Home Status", style: TextStyle(fontSize: 18, color: Colors.white)),

                  isHome==true?new Icon(Icons.home, color:Colors.white, size:25.0):
                        new Icon(Icons.directions_walk, color:Colors.white, size:25.0),

                  new Switch(value: isHome, onChanged: onChangedSwitch,
                              activeColor:Colors.white),

                ],
              ),

            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 150.0,
        margin: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 15.0
        ),
        child: new Stack(
          children: <Widget>[
            userCard,
            userContent,
            userThumbnail,
          ],
        )
    );
  }

}
class UserList extends StatelessWidget {
  final List<User> users;
  UserList(this.users);

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, int) {
        return UserRow(users[int]);
      },
    );
  }
}
class Household extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff314C66),
      ),
      title: 'Gotcha',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Manage Household'),
            actions: <Widget>[
              new Padding(
                padding: EdgeInsets.only(right:10),
                child: new IconButton(icon: Icon(Icons.group_add, color: Colors.white), onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser()));})
              )
            ],
            centerTitle: true,
            leading: new IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white,),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        body: new Container(
          child: UserList(users),
        ),
      ),
    );
  }
}
