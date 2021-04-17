import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;

import 'GoogleAuthClient.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WavBak',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WAVBAK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,  title, this.appTitle}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String appTitle;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _state = "Welcome Screen";

  Future<void> _MakeState(String inputState) async {
    setState(() {

    });
    final googleSignIn = signIn.GoogleSignIn.standard(
        scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount account = (await googleSignIn.signIn());
    print("User account $account");


    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final Stream<List<int>> mediaStream = Future.value([104, 105]).asStream();
    var media = new drive.Media(mediaStream, 2);
    var driveFile = new drive.File();
    driveFile.name = "hello_world.txt";
    final result = await driveApi.files.create(driveFile, uploadMedia: media);
    print("Upload result: $result");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Image.asset('assets/images/Awavbaklogo.jpeg'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _MakeState("hello");
                   /* Navigator.push(
                      context,new MaterialPageRoute(builder: (context) => new signScreen()),
                    );*/
                  },

                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text("Signer"),
                    color: Colors.blue,
                    padding:EdgeInsets.all(30.0),
                    margin: EdgeInsets.all(20.00),

                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,new MaterialPageRoute(builder: (context) => new waverScreen()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text("Waver"),
                    color: Colors.blue,
                   padding:EdgeInsets.all(30.0),
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

class waverScreen extends StatelessWidget {
  @override
  Widget build (BuildContext context){
    return new Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            //Image.asset('assets/images/Awavbaklogo.jpeg'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,new MaterialPageRoute(builder: (context) => new selectionScreen()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text("Select"),
                    color: Colors.blue,
                    padding:EdgeInsets.all(30.0),
                    margin: EdgeInsets.all(20.00),

                  ),
                ),
                ElevatedButton(
                  onPressed: () {

                    Navigator.push(
                      context,new MaterialPageRoute(builder: (context) => new selectionScreen()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text("Create"),
                    color: Colors.blue,
                    padding:EdgeInsets.all(30.0),
                    margin: EdgeInsets.all(20.00),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}

class selectionScreen extends StatelessWidget {
  @override
  Widget build (BuildContext context){
    return Scaffold(

    );
  }
}

class creationScreen extends StatelessWidget {
  @override
  Widget build (BuildContext context){
    return Scaffold(

    );
  }
}

class signScreen extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return Scaffold(

    );
  }
}

