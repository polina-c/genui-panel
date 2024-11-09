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
      return _AuthButton('Sign Out', _handleSignOut);
    } else {
      return _AuthButton('Sign In', _handleSignIn);
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      setState(() => _isSignedIn = true);
    } catch (error) {
      print('!!!! error in _handleSignIn: $error');
    }
  }

  void _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      setState(() => _isSignedIn = false);
    } catch (error) {
      print('!!!! error in _handleSignOut: $error');
    }
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton(this.text, this.onPressed);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FittedBox(
          child: Text(text),
        ),
      ),
    );
  }
}
