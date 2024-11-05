import 'package:flutter/material.dart';
import 'package:ui/screens/content.dart';
import 'package:ui/screens/sidebar.dart';
import 'package:ui/screens/unknown.dart';
import 'shared/primitives/app_scaffold.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gen UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.unknown,
      // Using this instead of [routes] to turn off animation during navigation.
      onGenerateRoute: (settings) {
        final route = settings.name ?? AppRoutes.unknown;
        return PageRouteBuilder(
          pageBuilder: (context, __, ___) =>
              AppScaffold(content: _screens[route] ?? _unknownScreenBuilder),
          transitionsBuilder: (_, __, ___, child) => child,
          settings: settings,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        title: Text(widget.title),
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
