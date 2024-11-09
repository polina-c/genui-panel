import 'package:flutter/material.dart';
import 'package:ui/screens/sidebar/sign_in.dart';

import '../../shared/primitives/post_message/post_message.dart';

class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  int _counter = 0;
  final _text = TextEditingController(text: 'Generate something nice, please!');

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    onPostMessage.listen((event) {
      print('!!!! dart received message: ${event.origin}, ${event.data}');
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      postMessage('!!!! Counter is $_counter now!', '*');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Gen UI"),
        // This is to disable back button.
        leading: const SizedBox.shrink(),
      ),
      body: SizedBox(
        height: 1200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                TextField(
                  controller: _text,
                  keyboardType: TextInputType.multiline,
                  minLines:
                      5, // It does not limit input, but defines the min height of the input.
                  maxLines:
                      15, // It does not limit input, but defines the max height of the input.
                ),
                const Text(
                  'Enter your prompt here',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    postMessage('We want to generate something 🤷‍♀️', '*');
                  },
                  child: const Text('Generate UI!'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: SignIn(),
    );
  }
}
