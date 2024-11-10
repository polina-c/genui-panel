import 'package:flutter/material.dart';

import '_prompt_examples.dart';

class ExampleDropdown extends StatefulWidget {
  const ExampleDropdown({super.key});

  @override
  State<ExampleDropdown> createState() => _ExampleDropdownState();
}

class _ExampleDropdownState extends State<ExampleDropdown> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return promptExamples.asMap().entries.map((e) {
          final isSelected = e.key == _selectedIndex;
          return PopupMenuItem<int>(
            value: e.key,
            child: Text(
              e.value.name,
              style: TextStyle(color: isSelected ? Colors.amber : Colors.green),
            ),
            onTap: () => setState(() => _selectedIndex = e.key),
          );
        }).toList();
      },
    );
  }
}
