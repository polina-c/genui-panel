import 'dart:math';

import 'package:flutter/material.dart';

class _JsonFields {
  static const String panelName = 'panelName';
  static const String index = 'index';
  static const String icon = 'icon';
  static const String color = 'color';
  static const String prompt = 'prompt';
}

class GenUi {
  GenUi({
    required this.panelName,
    this.index,
    required this.icon,
    required this.color,
    required this.prompt,
  });

  GenUi.fromJson(Map<String, dynamic> json)
      : panelName = json[_JsonFields.panelName] as String,
        index = json[_JsonFields.index] as int?,
        icon = json[_JsonFields.icon] as int,
        color = json[_JsonFields.color] as int,
        prompt = json[_JsonFields.prompt] as String;

  GenUi.random({required this.panelName, required this.prompt, this.index}) {
    icon = random.nextInt(icons.length);
    color = random.nextInt(colors.length);
  }

  final random = Random();

  Map<String, dynamic> toJson() => {
        _JsonFields.panelName: panelName,
        _JsonFields.index: index,
        _JsonFields.icon: icon,
        _JsonFields.color: color,
        _JsonFields.prompt: prompt,
      };

  final String panelName;
  final int? index;

  String get uiId => index == null ? panelName : '$panelName,$index';

  late final int icon;
  late final int color;
  final String prompt;

  Color get colorValue => colors[color];
  IconData get iconValue => icons[icon];

  static final colors = <Color>[
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lime,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.yellow,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
    Colors.limeAccent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.yellowAccent,
    Colors.amberAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
  ];

  static final icons = <IconData>[
    Icons.face,
    Icons.favorite,
    Icons.star,
    Icons.thumb_up,
    Icons.check,
    Icons.close,
    Icons.done,
    Icons.done_all,
    Icons.done_outline,
    Icons.face_5,
    Icons.face_6,
    Icons.dangerous,
    Icons.warning,
    Icons.error,
    Icons.error_outline,
    Icons.track_changes,
    Icons.trending_up,
    Icons.trending_down,
    Icons.trending_flat,
    Icons.trending_neutral,
    Icons.upcoming,
  ];
}
