import 'package:flutter/material.dart';
import 'package:ui/screens/sidebar/_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../shared/primitives/post_message/post_message.dart';

class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  static const _defaultPrompt = 'Generate something nice, please.';
  final _text = TextEditingController();
  final _auth = SignInController();

  @override
  void dispose() {
    _text.dispose();
    _auth.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    onPostMessage.listen((event) {
      print(
          '!!!! dart sidebar received message: ${event.origin}, ${event.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Gen UI"),
        // This is to disable back button.
        leading: const SizedBox.shrink(),
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
                  // It does not limit input, but defines the min height of the input:
                  minLines: 2,
                  // It does not limit input, but defines the max height of the input, after which it scrolls:
                  maxLines: 15,
                  autofocus: true,
                ),
                const Text(
                  'Enter your prompt here',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _requestGenUi();
                    postMessage('We want to generate something 🤷‍♀️', '*');
                  },
                  child: const Text('Generate UI'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: const SignIn(),
    );
  }

  void _requestGenUi() async {
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await _auth.currentUser!.authHeaders,
    );
  }
}
