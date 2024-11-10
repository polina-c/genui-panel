import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/primitives/horizontal_card.dart';

import '../../shared/primitives/scrolled_text.dart';

class GenUiCard extends StatefulWidget {
  const GenUiCard();

  @override
  State<GenUiCard> createState() => _GenUiCardState();
}

class _GenUiCardState extends State<GenUiCard> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() => _isLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    const size = 420.0;

    return HorizontalCard(
      height: size,
      child: _isLoaded
          ? const _CardContentLoaded(size)
          : const _CardContentWaiting(),
    );
  }
}

class _CardContentWaiting extends StatelessWidget {
  const _CardContentWaiting();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
      ],
    );
  }
}

class _CardContentLoaded extends StatelessWidget {
  const _CardContentLoaded(this.size);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              child: FittedBox(
                child: _GenUi(),
              ),
              width: size,
            ),
            const VerticalDivider(),
            const SizedBox(width: 8),
            ScrollableText(_code),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
              icon: const Icon(Icons.copy, color: Colors.grey),
              onPressed: () async {
                await Clipboard.setData(const ClipboardData(text: _code));
              }),
        ),
      ],
    );
  }
}

const _code = '''
class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const CircularProgressIndicator();
    }

    const size = 256.0;

    return Card(
      color: Colors.white,
      elevation: 4,
      child: SizedBox(
        child: FittedBox(
          child: _GenUi(),
        ),
        height: size,
        width: size,
      ),
    );
  }
}
''';

class _GenUi extends StatelessWidget {
  _GenUi();

  final random = Random();

  final _colors = <Color>[
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
  ];

  final _icons = <IconData>[
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

  @override
  Widget build(BuildContext context) {
    return Icon(
      _icons[random.nextInt(_icons.length)],
      color: _colors[random.nextInt(_colors.length)],
    );
  }
}
