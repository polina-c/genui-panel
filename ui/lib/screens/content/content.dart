import 'package:flutter/material.dart';

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
            children: [
              Text(widget.prompt ?? '<No prompt>'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Reveal'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _Content(),
        ],
      ),
    ));
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      color: Colors.amber,
      child: Icon(Icons.integration_instructions_rounded),
    );
  }
}
