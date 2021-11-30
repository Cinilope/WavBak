

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/documents.readonly',
    'https://www.googleapis.com/auth/drive.readonly'
  ],
);

class AuthManager {
  static Future<GoogleSignInAccount> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      print('account: ${account?.toString()}');
      return account;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<GoogleSignInAccount> signInSilently() async {
    var account = await _googleSignIn.signInSilently();
    print('account: $account');
    return account;
  }

  static Future<void> signOut() async {
    try {
      _googleSignIn.disconnect();
    } catch (error) {
      print(error);
    }
  }
}

Future<void> signInSilently() async {
  var account = await AuthManager.signInSilently();
  if (account != null) {
   // Navigator.pushReplacementNamed(context, AppRoute.files);
  }
}


Future<void> _handleSignIn() async {
  var account = await AuthManager.signIn();
  if (account != null) {
   // Navigator.pushReplacementNamed(context, AppRoute.files);
  }
}

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoute.login:
      return MaterialPageRoute(
     //   builder: (context) => LoginPage(),
      );
    case AppRoute.files:
      return MaterialPageRoute(
       // builder: (context) => FilesPage(),
      );
    case AppRoute.document:
      final args = settings.arguments as Map;
      return MaterialPageRoute(
      //  builder: (context) => DocumentPage(fileId: args[Args.fileId]),
      );
    default:
      return null;
  }
}

class Args {
  static const fileId = 'fileId';
}

class AppRoute {
  static const login = '/login';
  static const files = '/files';
  static const document = '/document';
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Text(
              'Log in using your Google account',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('Log in'),
              onPressed: _handleSignIn,
            ),
            Spacer(),
          ],
        ),
      ),
    ),
  );
}