import 'package:flutter/material.dart';

class GenUi extends StatefulWidget {
  const GenUi({super.key});

  @override
  State<GenUi> createState() => _GenUiState();
}

class _GenUiState extends State<GenUi> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const Placeholder();
    return Scaffold(
      body: Column(
        children: [
          const Text('gen UI'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
