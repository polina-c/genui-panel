import 'package:flutter/material.dart';

WidgetBuilder getNextStub() {
  return _stubs[0];
}

final _stubs = <WidgetBuilder>[
  (_) => const MyWidget(),
];

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Text('I am stub');
  }
}
