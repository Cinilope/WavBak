import 'dart:ffi';
import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:path_provider/path_provider.dart';

import 'package:wavbak/Drive/http_client.dart';
import 'package:wavbak/Drive/PDF preview.dart';
import 'package:download_assets/download_assets.dart';
import 'package:wavbak/sig/signature_preview_page.dart';

//https://github.com/rxlabz/flutter_gdrive_demo
// this file opens the open files
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive.file',
  ],
);

class DriveScreen extends StatefulWidget {
  @override
  DriveScreenState createState() {
    return new DriveScreenState();
  }
}

class DriveScreenState extends State<DriveScreen> {
  GoogleSignInAccount account;

  ga.DriveApi api;

  GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text('Drive information'),
        actions: account == null
            ? []
            : <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: logout)
        ],
      ),
      body: Center(
        child: account == null
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(child: Text('Login'), onPressed: login),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                    NetworkImage(account.photoUrl, scale: 0.3),
                    backgroundColor: Colors.yellow,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(account.displayName),
                )
              ],
            ),
            Expanded(
              child: FutureBuilder(
                  initialData: null,
                  //q:"'Wavers' in parents"
                  future: api.files.list(q:"'1P-d8u1qKAy8Xj8pO-xDC3Smpml5YcgS1' in parents"),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: (snapshot.data as ga.FileList)
                            .files
                            .map((f) =>ListTile(
                          dense: true,
                          title: Text(f.name),
                          leading: Icon(Icons.insert_drive_file),
                          onTap: () =>  _downloadGoogleDriveFile(f.name,f.id),
                        ))
                            .toList(),
                      );
                    }
                    if (snapshot.hasError)
                      return Center(
                        child: Text('Error ${snapshot.error}'),
                      );
                    return SizedBox();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      account = await _googleSignIn.signIn();
      final client =
      GoogleHttpClient(await _googleSignIn.currentUser.authHeaders);
      api = ga.DriveApi(client);
    } catch (error) {
      print('DriveScreen.login.ERROR... $error');
      _scaffold.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade700,
        content: Text(
          'Error : $error',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
    setState(() {});
  }








 Future<void> _downloadGoogleDriveFile(String fName, String gdID) async {


    ga.Media file = await api.files
        .get(gdID, downloadOptions: ga.DownloadOptions.fullMedia);
    print(file.stream);

    final directory = await getExternalStorageDirectory();
    print(directory.path);
    final saveFile = File('${directory.path}/${new DateTime.now().millisecondsSinceEpoch}$fName');
    List<int> dataStore = [];
    file.stream.listen((data) {
      print("DataReceived: ${data.length}");
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      print("Task Done");
      saveFile.writeAsBytes(dataStore);

      if(saveFile.path.endsWith(".pdf")) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(path: saveFile.path),
          ),
        );
      }
      else if (saveFile.path.endsWith(".png"))
      {
        var bytes  =  await saveFile.readAsBytes();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  SignaturePreviewPage(signature: bytes),
          ),
        );
      }
      print("File saved at ${saveFile.path}");
    }, onError: (error) {
      print("Some Error");
    });
  }


  void logout() {
    _googleSignIn.signOut();
    setState(() {
      account = null;
    });
  }
}