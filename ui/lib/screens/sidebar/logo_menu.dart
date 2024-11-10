import 'package:flutter/material.dart';

import '../../shared/primitives/logo_icon.dart';
import '_sign_in.dart';

class LogoMenu extends StatefulWidget {
  const LogoMenu();

  @override
  State<LogoMenu> createState() => _LogoMenuState();
}

class _LogoMenuState extends State<LogoMenu> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    GenUiAuth.onUserChange.listen((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const LogoIcon(),
      itemBuilder: (BuildContext context) {
        if (GenUiAuth.currentUser == null) {
          return _signedInItems();
        } else {
          return _signedInItems();
        }
      },
    );
  }

  List<PopupMenuItem<String>> _signedOutItems() {
    return const [
      PopupMenuItem<String>(
        child: Text('Sign In'),
        value: 'signIn',
        onTap: GenUiAuth.signIn,
      ),
    ];
  }

  List<PopupMenuItem<String>> _signedInItems() {
    return [
      const PopupMenuItem<String>(
        child: Text('Sign Out'),
        value: 'signOut',
        onTap: GenUiAuth.signOut,
      ),
    ];
  }
}
