import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// The scopes that the app needs.
///
/// See full list of scopes here: https://developers.google.com/identity/protocols/oauth2/scopes
const List<String> _scopes = <String>[
  //'email',
  //'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // The same as in <meta> in index.html in web folder.
  clientId:
      '975757934897-7aca7oc2f00qeqrhaaadasktspv4f60d.apps.googleusercontent.com',
  scopes: _scopes,
);

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return const FloatingActionButton(
        onPressed: null,
        child: Text('Sign Out'),
      );
    } else {
      return FloatingActionButton(
        onPressed: _handleSignIn,
        child: const Text('Sign In'),
      );
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isSignedIn = true;
      });
    } catch (error) {
      print('!!!! error in _handleSignIn: $error');
    }
  }
}
