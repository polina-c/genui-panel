import 'package:flutter/material.dart';
import 'screens/content/content.dart';
import 'screens/sidebar/sidebar.dart';
import 'screens/unknown.dart';
import 'shared/primitives/app_navigation.dart';
import 'shared/primitives/no_animation_route.dart';

void main() {
  runApp(const MyApp());
}

Widget _unknownScreenBuilder(BuildContext context, Map<String, String> args) =>
    const UnknownScreen();

final _screens = <String, ScreenBuilder>{
  AppRoutes.unknown: _unknownScreenBuilder,
  AppRoutes.sidebar: (_, __) => const SidebarScreen(),
  AppRoutes.content: (_, args) => ContentScreen(prompt: args['prompt'] ?? ''),
};

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gen UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      onGenerateRoute: (settings) {
        print('!!! generating route: name:${settings.name}');
        final uri = Uri.parse(settings.name ?? AppRoutes.unknown);
        print('!!! ${uri.path}, ${uri.queryParameters}');
        final builder = _screens[uri.path] ?? _unknownScreenBuilder;
        return NoAnimationMaterialPageRoute(
          builder: (context) => builder(context, uri.queryParameters),
        );
      },
    );
  }
}
