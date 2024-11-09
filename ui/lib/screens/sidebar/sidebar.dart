import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import '../../shared/primitives/post_message/post_message.dart';
import '_sign_in.dart';

const IconData _logo = IconData(0xe900, fontFamily: 'icomoon');

class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  static const _defaultPrompt = 'Generate something nice, please.';
  final _text = TextEditingController();
  final _auth = SignInController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _text.dispose();
    _auth.dispose();
    _focus.dispose();
    // It seems [onPostMessage] does not provide a way to remove listeners.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    onPostMessage.listen(_handleMessage);
    _auth.addListener(_handleAuthChange);
  }

  void _handleMessage(PostMessageEvent event) {
    print('!!!! dart sidebar received message: ${event.origin}, ${event.data}');
  }

  void _handleAuthChange() {
    if (_auth.currentUser != null) {
      _focus.requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gen UI'),
        // See https://stackoverflow.com/questions/44087400/flutter-svg-rendering.
        leading: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SvgPicture.asset(
            'assets/logo.svg',
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
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
                const Text(
                  'Enter your prompt here',
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

  void _requestGenUi() async {
    postMessage('We want to generate something 🤷‍♀️', '*');
    final response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await _auth.currentUser!.authHeaders,
    );
    print('Response status: ${response.statusCode}');
  }
}
