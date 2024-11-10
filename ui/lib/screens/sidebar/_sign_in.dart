import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:google_sign_in/google_sign_in.dart' as google_sign_in;

/// The scopes that the app needs.
///
/// See full list of scopes here: https://developers.google.com/identity/protocols/oauth2/scopes
const List<String> _scopes = <String>[];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Mast be the same as in <meta> in index.html in web folder.
  clientId:
      // ignore: lines_longer_than_80_chars
      '975757934897-7aca7oc2f00qeqrhaaadasktspv4f60d.apps.googleusercontent.com',
  scopes: _scopes,
);

class SignInController extends ChangeNotifier {
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get currentUser => _user;
  set currentUser(GoogleSignInAccount? value) {
    _user = value;
    notifyListeners();
  }

  void resetUser() {
    _user = _googleSignIn.currentUser;
    notifyListeners();
  }

  // /// TODO: follow up on this
  // ///
  // /// The `signIn` method is discouraged on the web because it can't reliably provide an `idToken`.
  // /// Use `signInSilently` and `renderButton` to authenticate your users instead.
  // /// Read more: https://pub.dev/packages/google_sign_in_web
  // Future<void> initiateSignIn() async {
  //   await _googleSignIn.signInSilently();
  // }

  @override
  void dispose() {
    _user = null;
    super.dispose();
  }
}

class SignInButton extends StatefulWidget {
  const SignInButton({super.key, this.controller});

  final SignInController? controller;

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  GoogleSignInAccount? _currentUser;

  @override
  void didUpdateWidget(covariant SignInButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      widget.controller?.currentUser = _currentUser;
    }
  }

  void _handleCurrentUserChange(GoogleSignInAccount? account) {
    widget.controller?.currentUser = account;
    setState(() => _currentUser = account);
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen(_handleCurrentUserChange);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return _AuthButton('Sign In', _googleSignIn.signIn);
    } else {
      return _AuthButton('Sign Out', _googleSignIn.signOut);
    }
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton(this.text, this.onPressed);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
