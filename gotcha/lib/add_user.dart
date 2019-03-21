import 'package:flutter/material.dart';
import 'main.dart';
import 'test_pictures.dart';

//void main() => runApp(MyApp());

class AddUserPage extends StatefulWidget {
  @override
  _AddUserState createState() => new _AddUserState();
}

class _AddUserState extends State<AddUserPage> {
  int residentStatus = 0;
  int unlockOptions = 0;
  int notifyOptions = 0;

  void handleResidentChange(int value)
  {
    setState(() {
      residentStatus = value;
    });
  }

  void handleUnlockChange(int value)
  {
    setState(() {
      unlockOptions = value;
    });
  }

  void handleNotifyChange(int value)
  {
    setState(() {
      notifyOptions = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add New User',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: new IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: () {Navigator.pop(context);}),
          title: Text('Add New User'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'First Name:'
                    ),
                    style: new TextStyle(fontSize: 25),
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Last Name:'
                    ),
                    style: new TextStyle(fontSize: 25),
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                child: new Align(
                  alignment: Alignment.topLeft,
                    child: new Text('Resident Status:', style: new TextStyle(fontSize: 25),)
                )
              ),

              new Padding(
                padding: EdgeInsets.only(top: 0),
               child: new Row(
                 children: <Widget>[
                   new Radio(
                     value: 1,
                     groupValue: residentStatus,
                     onChanged: handleResidentChange,
                   ),
                   new Text('Resident'),

                   new Radio(
                     value: 2,
                     groupValue: residentStatus,
                     onChanged: handleResidentChange,
                   ),
                   new Text('Guest'),

                   new Radio(
                     value: 3,
                     groupValue: residentStatus,
                     onChanged: handleResidentChange,
                   ),
                   new Text('Unwelcomed'),
                 ],
               )
              ),

              new Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: new Align(
                      alignment: Alignment.topLeft,
                      child: new Text('Door Unlock Options:', style: new TextStyle(fontSize: 25),)
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: new Row(
                    children: <Widget>[
                      new Radio(
                        value: 1,
                        groupValue: unlockOptions,
                        onChanged: handleUnlockChange,
                      ),
                      new Text('Always'),

                      new Radio(
                        value: 2,
                        groupValue: unlockOptions,
                        onChanged: handleUnlockChange,
                      ),
                      new Text('Ask Me First'),

                      new Radio(
                        value: 3,
                        groupValue: unlockOptions,
                        onChanged: handleUnlockChange,
                      ),
                      new Text('Never'),
                    ],
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: new Align(
                      alignment: Alignment.topLeft,
                      child: new Text('Notify Me:', style: new TextStyle(fontSize: 25),)
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: new Row(
                    children: <Widget>[
                      new Radio(
                        value: 1,
                        groupValue: notifyOptions,
                        onChanged: handleNotifyChange,
                      ),
                      new Text('Yes'),

                      new Radio(
                        value: 2,
                        groupValue: notifyOptions,
                        onChanged: handleNotifyChange,
                      ),
                      new Text('No'),
                    ],
                  )
              ),

              new Row(
                children: <Widget>[
                  new Expanded(
                      child: Padding(
                        child: RaisedButton(
                          child: Text("Menu", style: new TextStyle(fontSize: 20),),
                          onPressed: () => null,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)
                          ),
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                      )
                  ),
                  new Expanded(
                      child: Padding(
                        child: RaisedButton(
                          child: Text("Continue", style: new TextStyle(fontSize: 20),),
                          onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => Pictures()));},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                        padding: EdgeInsets.only(left: 7, right: 7),
                      )
                  ),
                ],
              ),

            ],
          )
        ),
      ),
    );
  }
}