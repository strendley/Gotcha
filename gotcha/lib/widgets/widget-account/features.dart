import 'package:flutter/material.dart';
import 'homepage.dart';


class FeaturesPage extends StatelessWidget {
  FeaturesPage({Key key, this.email}) : super(key:key);

  final String email;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha App',
      theme: ThemeData(
          primaryColor: Color(0xff314c66)
      ),

      home: Features(
        title: 'Features', 
        email: email
      ),
    );
  }
}

class Features extends StatefulWidget {
  Features({Key key, this.title, this.email}) : super(key: key);
  final String title;
  final String email;

  @override
  _FeaturesState createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  Color _primaryColor = Color(0xff314C66);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Features',
      theme: ThemeData(
          primaryColor: _primaryColor
      ),
      
      home: Scaffold(

        backgroundColor: _primaryColor,
        
        appBar: AppBar(
          leading: new IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ), 
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          title: Text('About'),
          centerTitle: true,
        
          actions: <Widget>[
        
            new IconButton(
              icon: Image.asset("gotcha.png"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(email: widget.email),
                  ),
                );
              },
            ),
        
          ],
        ),


        body: Container(
          child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
            child: Column(
            children: <Widget>[

              SizedBox(height: 20),

          Text('Gotcha was designed and developed by a small team of undergradute students at MST.'
              ' The project was done for Software Systems Development, a class taught by our lord and savior,'
              ' Mr. Gilbert Gosenell.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffD9E8FD), 
            fontWeight: FontWeight.bold, 
            fontSize: 18),
          ),

          new Image.asset('lib/data/img/gosnellgod.png', height: 400, width: 400,),

              ],
          ),
        ),
      ),
      ),
    );
  }
}
