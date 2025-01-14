import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../shared/primitives/ui/app_navigation.dart';
import '../shared/primitives/ui/app_scaffold.dart';
import '../shared/primitives/constants.dart';

// Shows a list of all routes in the app.
class UnknownScreen extends StatefulWidget {
  const UnknownScreen({super.key});

  @override
  State<UnknownScreen> createState() => _UnknownScreenState();
}

class _UnknownScreenState extends State<UnknownScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          children: AppRoutes.routes.map((String r) {
            return Link(
              uri: Uri.parse(r),
              builder: (context, followLink) {
                return TextButton(
                  onPressed: followLink,
                  child: Text(r),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
