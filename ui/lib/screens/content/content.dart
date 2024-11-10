import 'package:flutter/material.dart';

import '../../shared/primitives/in_ide_message.dart';
import '../../shared/primitives/post_message/post_message.dart';

class ContentScreen extends StatefulWidget {
  ContentScreen({super.key, String? prompt}) {
    if (prompt == '') {
      prompt = null;
    }
    // ignore: prefer_initializing_formals, false positive
    this.prompt = prompt;
  }

  late final String? prompt;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.prompt ?? '<No prompt>', maxLines: 5),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => postMessageToAll(
                    RevealMessage(widget.prompt ?? '').jsonEncode(),
                  ),
                  child: const Text('Reveal'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            const _Content(),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const CircularProgressIndicator();
    }
    return const Placeholder(
      color: Colors.amber,
      child: Icon(Icons.integration_instructions_rounded),
    );
  }
}
