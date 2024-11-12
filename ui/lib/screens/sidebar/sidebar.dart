import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

import '../../shared/primitives/app_scaffold.dart';
import '../../shared/in_ide_message.dart';
import '../../shared/primitives/logo_icon.dart';
import '../../shared/primitives/post_message/post_message.dart';
import '../../shared/primitives/post_message/primitives.dart';
import '_prompt_input.dart';
import '_settings.dart';
import '_sign_in.dart';

class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  final _text = TextEditingController();
  final _auth = SignInController();
  final _focus = FocusNode();
  final _settings = SettingsController();
  late final GoogleSignInPlugin _googleSignIn;

  @override
  void dispose() {
    _text.dispose();
    _auth.dispose();
    _focus.dispose();
    _settings.dispose();
    unawaited(_googleSignIn.disconnect());
    // It seems [onMessagePosted] does not provide a way to remove listeners.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    unawaited(_initSignIn());
    onMessagePosted.listen(_handleMessage);
    _auth.addListener(_handleAuthChange);
  }

  Future<void> _initSignIn() async {
    _googleSignIn = GoogleSignInPlugin();
    await _googleSignIn.init();
    _auth.resetUser();
  }

  void _handleMessage(PostMessageEvent event) {
    print('!!!! dart sidebar received message: ${event.origin}, ${event.data}');
    final data = event.data as String;
    final message = messageFromJson(data) as RevealPromptMessage;
    print('!!!! dart sidebar parsed message: ${message.prompt}');
    _text.text = message.prompt;
    print('!!!! dart sidebar updated message: ${message.prompt}');
  }

  void _handleAuthChange() {
    if (_auth.currentUser != null) {
      _focus.requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Gen UI', style: TextStyle(color: primaryColor)),
        // See https://stackoverflow.com/questions/44087400/flutter-svg-rendering.
        leading: const Padding(
          padding: EdgeInsets.all(14.0),
          child: LogoIcon(),
        ),
        actions: <Widget>[
          // It looks amazing, but it does not work as expected.
          // _googleSignIn.renderButton(),
          SignInButton(controller: _auth),
        ],
      ),
      body: SizedBox(
        height: 1200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                PromptInput(_text),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SettingsExpandableButton(_settings),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _requestGenUi,
                  child: const Text('Generate UI'),
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.resolveWith<double>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.disabled)) {
                          return 0;
                        }
                        return 4;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _requestGenUi() {
    if (_auth.currentUser == null) {
      // TODO: figure out how to trigger sign in.
      // This guidance does not work as expected:
      // /// The `signIn` method is discouraged on the web because it can't reliably provide an `idToken`.
      // /// Use `signInSilently` and `renderButton` to authenticate your users instead.
      // /// Read more: https://pub.dev/packages/google_sign_in_web
    }
    postMessageToAll(GenerateUiMessage(
      prompt: _text.text,
      numberOfOptions: _settings.numberOfOptions,
      openOnSide: _settings.openOnSide,
    ).jsonEncode());

    // final response = await http.get(
    //   Uri.parse('https://people.googleapis.com/v1/people/me/connections'
    //       '?requestMask.includeField=person.names'),
    //   headers: await _auth.currentUser!.authHeaders,
    // );
    // print('Response status: ${response.statusCode}');
  }
}
