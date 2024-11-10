import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/primitives/in_ide_message.dart';
import '../../shared/primitives/post_message/post_message.dart';

import '_scrolled_text.dart';

class ContentScreen extends StatefulWidget {
  ContentScreen({super.key, String? prompt}) {
    if (prompt == '') {
      prompt = null;
    }
    // ignore: prefer_initializing_formals, false positive
    this.prompt = prompt;
  }

  late final String? prompt;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.prompt ?? '<No prompt>', maxLines: 5),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => postMessageToAll(
                    RevealMessage(widget.prompt ?? '').jsonEncode(),
                  ),
                  child: const Text('Reveal'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _Card(),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatefulWidget {
  const _Card();

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
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
    const size = 256.0;

    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: size,
          child: _isLoaded
              ? const _CardContentLoaded(size)
              : const _CardContentWaiting(),
        ),
      ),
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
            ScrolledText(_code),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
              icon: const Icon(Icons.copy),
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
    Icons.thumb_down,
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
