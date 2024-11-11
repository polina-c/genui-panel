import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/content/content.dart';
import 'screens/sidebar/sidebar.dart';
import 'screens/unknown.dart';
import 'shared/primitives/app_navigation.dart';
import 'shared/primitives/constants.dart';
import 'shared/primitives/no_animation_route.dart';

void main() {
  runApp(const MyApp());
}

Widget _unknownScreenBuilder(BuildContext context, Map<String, String> args) =>
    const UnknownScreen();

final _screens = <String, ScreenBuilder>{
  AppRoutes.unknown: _unknownScreenBuilder,
  AppRoutes.sidebar: (_, __) => const SidebarScreen(),
  AppRoutes.content: (_, args) {
    final prompt = args['prompt'] ?? '';
    final numberOfOptions = int.tryParse(args['numberOfOptions'] ?? '1') ?? 1;
    final uiSizePx = int.tryParse(args['uiSizePx'] ?? '16') ?? defaultUiSizePx;
    return ContentScreen(
      prompt: prompt,
      numberOfOptions: numberOfOptions,
      uiSizePx: uiSizePx,
    );
  },
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
      debugShowCheckedModeBanner: false,
      title: 'Gen UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      onGenerateRoute: (settings) {
        print('!!! generating route: name:${settings.name}');
        final uri = Uri.parse(settings.name ?? AppRoutes.unknown);
        print('!!! ${uri.path}, ${uri.queryParameters}');
        unawaited(SystemNavigator.routeInformationUpdated(uri: uri));
        final builder = _screens[uri.path] ?? _unknownScreenBuilder;
        return NoAnimationMaterialPageRoute(
          builder: (context) => builder(context, uri.queryParameters),
        );
      },
    );
  }
}
