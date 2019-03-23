import 'package:flutter/material.dart';
import '../widget-camera/test_pictures.dart';

class AddUser extends StatelessWidget {
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
                    child: new Text('Resident Status?', style: new TextStyle(fontSize: 25),)
                )
              ),

              new Padding(
                padding: EdgeInsets.only(top: 0),
               child: new Row(
                 children: <Widget>[
                   new Radio(
                     value: 0,
                     groupValue: null,
                     onChanged: null,
                   ),
                   new Text('Resident'),

                   new Radio(
                     value: 1,
                     groupValue: null,
                     onChanged: null,
                   ),
                   new Text('Guest'),

                   new Radio(
                     value: 1,
                     groupValue: null,
                     onChanged: null,
                   ),
                   new Text('Unwelcomed'),
                 ],
               )
              ),

              new Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: new Align(
                      alignment: Alignment.topLeft,
                      child: new Text('Door Unlock Options', style: new TextStyle(fontSize: 25),)
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: new Row(
                    children: <Widget>[
                      new Radio(
                        value: 2,
                        groupValue: null,
                        onChanged: null,
                      ),
                      new Text('Always'),

                      new Radio(
                        value: 3,
                        groupValue: null,
                        onChanged: null,
                      ),
                      new Text('Ask Me First'),

                      new Radio(
                        value: 4,
                        groupValue: null,
                        onChanged: null,
                      ),
                      new Text('Never'),
                    ],
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: new Align(
                      alignment: Alignment.topLeft,
                      child: new Text('Notify Me?', style: new TextStyle(fontSize: 25),)
                  )
              ),

              new Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: new Row(
                    children: <Widget>[
                      new Radio(
                        value: 5,
                        groupValue: null,
                        onChanged: null,
                      ),
                      new Text('Yes'),

                      new Radio(
                        value: 6,
                        groupValue: null,
                        onChanged: null,
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