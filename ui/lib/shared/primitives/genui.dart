import 'dart:math';

import 'package:flutter/material.dart';

class GenUi {
  GenUi({
    required this.panelName,
    this.index,
    required this.icon,
    required this.color,
  });

  GenUi.fromJson(Map<String, dynamic> json)
      : panelName = json['panelName'] as String,
        index = json['index'] as int?,
        icon = json['icon'] as int,
        color = json['color'] as int;

  GenUi.random({required this.panelName, this.index}) {
    icon = random.nextInt(icons.length);
    color = random.nextInt(colors.length);
  }

  final random = Random();

  Map<String, dynamic> toJson() => {
        'panelName': panelName,
        'index': index,
        'icon': icon,
        'color': color,
      };

  final String panelName;
  final int? index;

  String get uiId => index == null ? panelName : '$panelName,$index';

  late final int icon;
  late final int color;

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
