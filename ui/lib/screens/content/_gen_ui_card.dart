import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/in_ide_message.dart';
import '../../shared/primitives/genui_widget.dart';
import '../../shared/primitives/horizontal_card.dart';
import '../../shared/primitives/post_message/post_message.dart';
import '../../shared/primitives/scrolled_text.dart';

class GenUiCard extends StatefulWidget {
  GenUiCard({
    required int uiSizePx,
    required this.panelName,
    this.index,
    required this.prompt,
  }) : uiSizePx = uiSizePx.toDouble();

  final double uiSizePx;
  final String panelName;
  final int? index;
  final String prompt;

  @override
  State<GenUiCard> createState() => _GenUiCardState();
}

class _GenUiCardState extends State<GenUiCard> {
  bool _isLoaded = false;
  late final GenUi _genUi;

  @override
  void initState() {
    super.initState();
    _genUi = GenUi.random(
      prompt: widget.prompt,
      panelName: widget.panelName,
      index: widget.index,
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() => _isLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalCard(
      height: widget.uiSizePx,
      child: _isLoaded
          ? _CardContentLoaded(widget.uiSizePx, _genUi)
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
  const _CardContentLoaded(this.size, this.genUi);

  final double size;
  final GenUi genUi;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Positioned(
                  child: Text(
                    genUi.index?.toString() ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  top: 0,
                  left: 0,
                ),
                SizedBox(
                  child: FittedBox(
                    child: _GenUiRendered(genUi),
                  ),
                  width: size,
                ),
                TextButton(
                    onPressed: () => postMessageToAll(
                          RevealUiMessage(ui: genUi).jsonEncode(),
                        ),
                    child: const Text('Reveal')),
              ],
            ),
            const VerticalDivider(),
            const SizedBox(width: 8),
            ScrollableText(_code),
          ],
        ),
        IconButton(
            icon: const Icon(Icons.copy, color: Colors.grey),
            onPressed: () async {
              await Clipboard.setData(const ClipboardData(text: _code));
            }),
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

class _GenUiRendered extends StatefulWidget {
  _GenUiRendered(this.genUi);

  final GenUi genUi;

  @override
  State<_GenUiRendered> createState() => _GenUiRenderedState();
}

class _GenUiRenderedState extends State<_GenUiRendered> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.genUi.iconValue,
      color: widget.genUi.colorValue,
    );
  }
}
