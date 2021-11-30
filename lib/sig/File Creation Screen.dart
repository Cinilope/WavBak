import 'dart:ffi';
import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wavbak/sig/Signature_page.dart';
import 'package:wavbak/Globals.dart' as Globals;
class creationScreen extends StatefulWidget {
  @override
  _creationScreenState createState() => _creationScreenState();
}
//this is the screen that creates the file url
class _creationScreenState extends State<creationScreen> {
  final myController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/pen icon.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('Type name'))
            ],

          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("I have read and acknowledge the preceding document"
              ),
            TextField(
              keyboardType: TextInputType.text,
              maxLines: 1,
              controller: myController,
              onSubmitted: setname,
            ),
            ElevatedButton(
              onPressed: () {
                //myController.text
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SignaturePage()),
                );
              },
              child: Container(
                alignment: Alignment.bottomRight,
                child: Text("signature"),
                color: Colors.blue,
              ),
            ),
             ],
          ),

        ));


  }

  void setname(String value) {
    Globals.SignerName =  myController.text;
    print(Globals.SignerName);
  }
}