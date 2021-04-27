//@dart=2.9
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidget;
import 'pdf_editor_service.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

void main() {
  runApp(MyApp());
}

//SplashScreen class uses Timer class to display splash screen for 5 seconds
//To Do: Add fade out animation to make transition seamless
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 5), () => Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => MyHomePage())));

    return MaterialApp(
        home: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image:DecorationImage(
                  image: AssetImage('assets/images/splash_anim.gif')
                )
              )
            )

            )
        );
    }
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
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _state = "Welcome Screen";

 void _MakeState(String inputState) {
    setState(() {
      _state =  inputState;
    });
  }

  //This function makes calls to the pdf_editor_service library creating a
  //mutable pdf document that can be edited using the _editDocument function
  void _edit() async {
    PdfMutableDocument doc = await PdfMutableDocument.asset("assets/rhodes.pdf");
    print("pdfmutabledocument set");
    _editDocument(doc);
    await doc.save(filename: "modified.pdf");
    print("PDF Edition Done");
  }

  //This makes calls to the generic pdf library using pdfWidget to add text or other
  //elements to the pdf image
  void _editDocument(PdfMutableDocument document) {
    var page = document.getPage(0);
    page.add(item: pdfWidget.Positioned(
      left: 0.0,
      top: 0.0,
      child: pdfWidget.Text("COUCOU",
          style: pdfWidget.TextStyle(fontSize: 32, color: pdf.PdfColors.red)),
    ));
    var centeredText = pdfWidget.Center(
        child: pdfWidget.Text(
          "CENTERED TEXT",
          style: pdfWidget.TextStyle(
              fontSize: 40,
              color: pdf.PdfColors.green,
              background: pdfWidget.BoxDecoration(color: pdf.PdfColors.purple400)),
        ));
    page.add(item: centeredText);
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
           Container(
             child: Text(_state,
               textScaleFactor: 2,
                 textAlign: TextAlign.center,
                 style: TextStyle(fontWeight: FontWeight.bold)
      ),

             color: Colors.blue,
               padding:EdgeInsets.all(20.0),
             margin: EdgeInsets.all(20.00),

           ),
            Image.asset('assets/images/Awavbaklogo.jpeg'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    Directory directory = await getApplicationDocumentsDirectory();
                    var dirPath = directory.path;
                    var docPath = '$dirPath/rhodes.pdf';
                    ByteData data = await rootBundle.load("assets/rhodes.pdf");
                    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                    await File(docPath).writeAsBytes(bytes);
                    _edit();
                    Navigator.push(
                      context,new MaterialPageRoute(builder: (context) => new signScreen(path:'$dirPath/modified.pdf')),
                    );
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
      appBar: AppBar(title:Text('WavBack')),
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
      appBar: AppBar(title:Text('WavBack'))
    );
  }
}

class creationScreen extends StatelessWidget {
  @override
  Widget build (BuildContext context){
    return Scaffold(
        appBar: AppBar(title:Text('WavBack'))
    );
  }
}

class signScreen extends StatelessWidget{

  final String path;

  //Constructor
  signScreen({this.path});

  @override
  Widget build (BuildContext context){

    return PDFViewerScaffold(
      path:path,
      appBar: AppBar(title:Text('WavBack'))
      );
  }
}

