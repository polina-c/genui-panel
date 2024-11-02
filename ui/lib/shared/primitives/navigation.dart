import 'package:flutter/material.dart';

/// Not using enum, because some routes may have parameters and sub-routes.
class AppRoutes {
  static const String unknown = '/';
  static const String team = '/sidebar';
  static const String toys = '/content';
}

void push(String route, BuildContext context) {
  Navigator.of(context).pushNamed(route);
}
