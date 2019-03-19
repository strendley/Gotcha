import 'add_user.dart';
import 'package:flutter/material.dart';
import 'package:gotcha/user.dart';
//void main() => runApp(MyApp());

class UserRow extends StatefulWidget
{
  final User user;
  UserRow(this.user);

  @override
  _UserRowState createState() => _UserRowState(user);

}

class _UserRowState extends State<UserRow> {
  User user;

  _UserRowState(this.user);

  Widget get userThumbnail {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: new CircleAvatar(
        backgroundImage: AssetImage(user.image),
        maxRadius: 50,
      ),
      //height: 120.0,
      //width: 92.0,
    );
  }

  Widget get userCard {
    return new Container(
      height: 124.0,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: new Color(0xff4c346d),
          //color: new Color(0xfff7a992),
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
      margin: new EdgeInsets.fromLTRB(110.0, 10.0, 16.0, 10.0),
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
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Text(user.residentStatus + ' ' + user.unlockOptions,
                    style: TextStyle(fontSize: 18, color: Colors.white),),
                  new Container(
                    alignment: Alignment.bottomRight,
                    //color: Colors.red,
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
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 120.0,
        margin: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0
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
  // Builder methods rely on a set of data, such as a list.
  final List<User> users;
  UserList(this.users);

  // First, make your build method like normal.
  // Instead of returning Widgets, return a method that returns widgets.
  // Don't forget to pass in the context!
  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  // A builder method almost always returns a ListView.
  // A ListView is a widget similar to Column or Row.
  // It knows whether it needs to be scrollable or not.
  // It has a constructor called builder, which it knows will
  // work with a List.

  ListView _buildList(context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: users.length,
      // A callback that will return a widget.
      itemBuilder: (context, int) {
        // In our case, a DogCard for each doggo.
        return UserRow(users[int]);
      },
    );
  }
}
class Household extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha',
      home: Scaffold(
        //backgroundColor: Color(0xffecead3),
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
