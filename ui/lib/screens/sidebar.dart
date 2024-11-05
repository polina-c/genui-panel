import 'package:flutter/material.dart';

import '../shared/primitives/post_message/post_message.dart';

class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  int _counter = 0;

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
        title: Text("Gen UI Sidebar"),
      ),
      body: SizedBox(
        height: 1200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  postMessage('We want to generate something 🤷‍♀️', '*');
                },
                child: const Text('Generate something!'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
