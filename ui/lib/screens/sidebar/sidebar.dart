import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

import '../../shared/in_ide_message.dart';
import '../../shared/primitives/ui/app_scaffold.dart';
import '../../shared/primitives/ui/custom_icons.dart';
import '../../shared/primitives/ui/genui_widget.dart';
import '../../shared/primitives/post_message/post_message.dart';
import '../../shared/primitives/post_message/primitives.dart';
import 'data/_generate.dart';
import 'ui/_example_selector.dart';
import 'data/_prompt_examples.dart';
import 'ui/_prompt_input.dart';
import 'ui/_settings.dart';
import 'ui/_sign_in.dart';

class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key, required this.adjustUi});

  /// Whether to reveal the UI.
  ///
  /// This is test only, in prod it is always false, and
  /// normally reveal ui happens through message.
  final bool adjustUi;

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  final _auth = SignInController();
  final _focus = FocusNode();
  final _settings = SettingsController();
  late final GoogleSignInPlugin _googleSignIn;
  GenUi? _uiToAdjust;

  @override
  void dispose() {
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
    if (widget.adjustUi) {
      _uiToAdjust = GenUi.random(panelName: 'testui', prompt: 'test prompt');
    }
  }

  Future<void> _initSignIn() async {
    _googleSignIn = GoogleSignInPlugin();
    await _googleSignIn.init();
    _auth.resetUser();
  }

  void _handleMessage(PostMessageEvent event) {
    print(
        '!!!! dart sidebar: received message: ${event.origin}, ${event.data}');
    final data = event.data as String;
    final message = messageFromJson(data);
    print('!!!! dart sidebar: parsed message: ${message.type}');
    if (message is RevealPromptMessage) {
      _settings.prompt.text = message.prompt;
      setState(() => _uiToAdjust = null);
      _focus.requestFocus();
    } else if (message is RevealUiMessage) {
      _settings.prompt.text = '';
      setState(() => _uiToAdjust = message.ui);
      _focus.requestFocus();
    } else {
      throw Exception(
        'dart sidebar received unknown message: '
        '${message.runtimeType}, ${message.type}',
      );
    }
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                if (_uiToAdjust != null) ...[
                  Row(
                    children: [
                      SizedBox(
                        child: IconButton(
                          onPressed: () => setState(() => _uiToAdjust = null),
                          icon: const Icon(Icons.close),
                          iconSize: 16,
                        ),
                      ),
                      const Text('Editing   '),
                      GenUiReference(
                        uiToAdjust: _uiToAdjust!,
                        settings: _settings,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
                PromptInput(_settings.prompt,
                    uiToAdjust: _uiToAdjust?.uiId, focusNode: _focus),
                const SizedBox(height: 20),
                ExampleSelector(
                  onSelection: (PromptExample example) =>
                      _settings.prompt.text = example.prompt,
                ),
                const SizedBox(height: 20),
                GenerateBtnWithSettings(_settings),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GenUiReference extends StatelessWidget {
  const GenUiReference(
      {super.key, required this.uiToAdjust, required this.settings});

  final GenUi uiToAdjust;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => requestGenUi(settings, numberOfOptions: 1),
      child: Row(
        children: [
          const LeafsIcon(),
          const SizedBox(width: 4),
          Text(uiToAdjust.uiId),
        ],
      ),
    );
  }
}
