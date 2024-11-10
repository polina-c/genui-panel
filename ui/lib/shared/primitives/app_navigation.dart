import 'package:flutter/material.dart';

/// Not using enum, because some routes may have parameters and sub-routes.
class AppRoutes {
  static const String unknown = '/';
  static const String sidebar = '/sidebar';
  static const String content = '/content';

  static List<String> get routes => [sidebar, content];
}

void push(String route, BuildContext context) {
  Navigator.of(context).pushNamed(route);
}

typedef ScreenBuilder = Widget Function(
    BuildContext context, Map<String, String> params);
