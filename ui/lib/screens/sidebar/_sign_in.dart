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
  // Mast be the same as in <meta> in index.html in web folder.
  clientId:
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

  @override
  void dispose() {
    _user = null;
    super.dispose();
  }
}

class SignIn extends StatefulWidget {
  const SignIn({super.key, this.controller});

  final SignInController? controller;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GoogleSignInAccount? _currentUser;

  @override
  void didUpdateWidget(covariant SignIn oldWidget) {
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
    return FloatingActionButton(
      onPressed: onPressed,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FittedBox(
          child: Text(text),
        ),
      ),
    );
  }
}
