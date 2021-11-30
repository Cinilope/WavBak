import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wavbak/Drive/files_page.dart';
import 'package:wavbak/Drive/http_client.dart';
import 'package:wavbak/sig/Utils.dart';
import 'package:wavbak/Globals.dart' as Globals;
import 'package:wavbak/GoogleAuthClient.dart' as client;
import 'package:googleapis/drive/v3.dart' as ga;

//preview signatures here
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive.file',
  ],
);

class SignaturePreviewPage extends StatelessWidget {
  final Uint8List signature;

  const SignaturePreviewPage({
    Key key,
    @required this.signature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      leading: CloseButton(),
      title: Text('Store Signature'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.done),
          onPressed: () => storeSignature(context),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: Center(
      child: Image.memory(signature, width: double.infinity),
    ),
  );

  Future storeSignature(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name =  Globals.SignerName + " Signed "+ time+ '.png';
print(name);
toDrive(signature, name); //ImageGallerySaver.saveImage(signature, name: name);*/



    final isSuccess = true;  //result['isSuccess'];

    if (isSuccess) {
      Navigator.pop(context);

      Utils.showSnackBar(
        context,
        text: 'Saved',
        color: Colors.green,
      );
    } else {
      Utils.showSnackBar(
        context,
        text: 'Failed to save signature',
        color: Colors.red,
      );
    }

    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new DriveScreen()),
    );


  }


  void  toDrive(Uint8List data, String filename ) async {
    ga.DriveApi api;
    try {
      await _googleSignIn.signIn();
      final client =
      GoogleHttpClient(await _googleSignIn.currentUser.authHeaders);
      api = ga.DriveApi(client);
    } catch (error) {
     print("not signed in");

    }
    final gFile = ga.File();
    gFile.name =  filename;
    gFile.parents = ["1P-d8u1qKAy8Xj8pO-xDC3Smpml5YcgS1"];
    final dir = await getApplicationDocumentsDirectory();
    final localFile = io.File('${dir.path}/$filename');
    await localFile.create();
    await localFile.writeAsBytes(data);
    print( "got here");
    final createdFile = await api.files.create(gFile,
        uploadMedia: ga.Media(localFile.openRead(), localFile.lengthSync()));


    print( "created File" + createdFile.id);



  }
}