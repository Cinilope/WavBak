import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;

import 'GoogleAuthClient.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:signature/signature.dart';
import 'package:wavbak/sig/signature_page.dart';
import 'package:wavbak/Drive/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:wavbak/Drive/files_page.dart';
import 'package:wavbak/sig/File Creation Screen.dart';
import 'Globals.dart' as globals;
/*Acknowledgments
https://github.com/rxlabz/flutter_gdrive_demo
https://github.com/myvsparth/flutter_gdrive/tree/master
https://github.com/nodes-android/google-docs-viewer-flutter
https://github.com/JohannesMilke/signature_example/blob/master/

*/




void main() {
  globals.isLoggedIn = true;
  globals.SignerName = '';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WavBak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WAVBAK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, title, this.appTitle}) : super(key: key);


  final String appTitle;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  String _state = "Welcome Screen";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo anim1.gif'),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                ElevatedButton(
                  onPressed: () {
                    //_MakeState("hello");
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new DriveScreen()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text("Waver"),
                    color: Colors.blue,
                    padding: EdgeInsets.all(30.0),
                    margin: EdgeInsets.all(20.00),
                  ),
                ),
              ],
            )
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


// this is a debug screen
class waverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ui;
    return new Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/lines.gif'),
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Row(
                children: <Widget>[
                  Image.asset('assets/images/document icon.png',width: 200,height: 200, alignment: Alignment.center,),
                  //Image.asset('assets/images/pen icon.png',width: 200,height: 200, alignment: Alignment.center,),
                  //Image.asset('assets/images/form icon.png',width: 200,height: 200, alignment: Alignment.centerRight,),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new DriveScreen()),
                      );
                    },
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text("Select"),
                      color: Colors.blue,
                      padding: EdgeInsets.all(30.0),
                      margin: EdgeInsets.all(20.00),
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}











