import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared/primitives/in_ide_message.dart';
import '../../shared/primitives/post_message/post_message.dart';
import '../../shared/primitives/post_message/primitives.dart';
import '_sign_in.dart';

class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  static const _defaultPrompt = 'Describe UI you want to generate.';
  final _text = TextEditingController();
  final _auth = SignInController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _text.dispose();
    _auth.dispose();
    _focus.dispose();
    // It seems [onMessagePosted] does not provide a way to remove listeners.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    onMessagePosted.listen(_handleMessage);
    _auth.addListener(_handleAuthChange);
  }

  void _handleMessage(PostMessageEvent event) {
    print('!!!! dart sidebar received message: ${event.origin}, ${event.data}');
    final data = event.data as String;
    final message = messageFromJson(data) as RevealMessage;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Gen UI', style: TextStyle(color: primaryColor)),
        // See https://stackoverflow.com/questions/44087400/flutter-svg-rendering.
        leading: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SvgPicture.asset(
            'assets/logo.svg',
            colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            semanticsLabel: 'GenUI logo',
          ),
        ),
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
                TextField(
                  controller: _text,
                  decoration: const InputDecoration(hintText: _defaultPrompt),
                  keyboardType: TextInputType.multiline,
                  // Defines the min height:
                  minLines: 2,
                  // Defines the max height, before scrolling:
                  maxLines: 15,
                  autofocus: true,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _auth.currentUser == null ? null : _requestGenUi,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: SignIn(controller: _auth),
    );
  }

  void _requestGenUi() {
    postMessageToAll(GenerateUiMessage(_text.text).jsonEncode());
    // final response = await http.get(
    //   Uri.parse('https://people.googleapis.com/v1/people/me/connections'
    //       '?requestMask.includeField=person.names'),
    //   headers: await _auth.currentUser!.authHeaders,
    // );
    // print('Response status: ${response.statusCode}');
  }
}
