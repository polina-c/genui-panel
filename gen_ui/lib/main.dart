import 'package:flutter/material.dart';
import 'package:ui/screens/content.dart';
import 'package:ui/screens/sidebar.dart';
import 'package:ui/screens/unknown.dart';
import 'shared/primitives/navigation.dart';
import 'shared/primitives/post_message/post_message.dart';

void main() {
  runApp(const MyApp());
}

Widget _unknownScreenBuilder(BuildContext context) => const UnknownScreen();

final _screens = <String, WidgetBuilder>{
  AppRoutes.unknown: _unknownScreenBuilder,
  AppRoutes.sidebar: (_) => const SidebarScreen(),
  AppRoutes.content: (_) => const ContentScreen(),
};

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    print('!!! dart init started.');
    super.initState();

    onPostMessage.map((event) {
      print('!!! dart event1: $event');
      return event.data;
    });
    onPostMessage.listen((event) {
      print('!!! dart event2: $event');
    });
    print('!!! dart init done.');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gen UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.unknown,
      routes: _screens,
    );
  }
}
