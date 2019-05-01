import 'add_user.dart';
import 'package:flutter/material.dart';
import 'package:gotcha/data/mock/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../services/firebase-firestore-users.dart';

class Household extends StatefulWidget{
  Household({Key key, this.email}): super(key: key);

  final String email;

  @override
  _Household createState() => _Household();
}


class _Household extends State<Household> {
  String _email;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff314C66),
      ),
      title: 'Gotcha',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Manage Users'),
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
          child: UserList(email: widget.email),
        ),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  final String email;
  UserList({Key key, this.email}): super(key: key);

 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
                       .collection('accounts')
                       .document(email)
                       .collection('users')
                       .snapshots(),
      builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    default:
                      return _buildList(snapshot.data.documents);
                  }
                }
    );
  }
  ListView _buildList(context) {
    return ListView.builder(
      itemCount: context.length,
      itemBuilder: (documents, int)  {
        return UserRow(name: context[int].data['users'].toString());
      },
    );
  }
}

class UserRow extends StatefulWidget
{
  final String name;
  UserRow({
        Key key, 
        this.name,
        }) 
        :super(key:key);


  @override
  _UserRowState createState() => _UserRowState();

}

class _UserRowState extends State<UserRow> {
  // User user;
  bool isHome = false;
  Map<String, String> _user = <String, String>{
      "name_first" : "",
      "name_middle": "",
      "name_last": "",
      "notify": "",
      "resident_status": "",
      "unlock_option" : "",
    };
  
  @override
  void initState() { 
    DocumentReference documentReference = Firestore.instance
                                                  .collection('users')
                                                  .document(widget.name); 
    
    documentReference.get().then((res) {
    setState(() {
      res.data.forEach((k,v)=>{
          _user[k]=v,
          print("${k},${v}")
        });
      });
    });
  }

  void onChangedSwitch(bool value) => setState(() => isHome = value);

  Widget get userThumbnail {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 10.0),
      alignment: FractionalOffset.centerLeft,
      child: new CircleAvatar(
        backgroundImage: AssetImage('gotcha_signin.png'),
        maxRadius: 55,
      ),
        padding: const EdgeInsets.all(10.0), // borde width
    );
  }

  Widget get userCard {
    return new Container(
      height: 250.0,
      margin: new EdgeInsets.only(left: 0.0),
      decoration: new BoxDecoration(
        color:  new Color(0xff314c66),
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 5.0)
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
                  new Text("${_user["name_first"]}",
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
                  new Text('Resident Status:\n\t ${_user["resident_status"]} \nUnlock Options:\n\t ${_user["unlock_option"]}',
                    style: TextStyle(fontSize: 16, color: Colors.white),),
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

                  Text("Home Status", style: TextStyle(fontSize: 12, color: Colors.white)),

                  isHome==true?new Icon(Icons.home, color:Colors.white, size:20.0):
                        new Icon(Icons.directions_walk, color:Colors.white, size:20.0),

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
        height: 190.0,
        margin: EdgeInsets.symmetric(
            vertical: 18.0,
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