import 'dart:convert' as convert;

import 'package:meta/meta.dart';

import 'primitives/genui.dart';

// Rename carefully, because some names are hard coded in node.
// Should we use proto?
enum InIdeMessageType {
  generateUiMessage(MessageFromTo.fromSidebarToIde),
  experimentalWindowMessage(MessageFromTo.fromSidebarToIde),

  revealPromptMessage(MessageFromTo.fromContentToSidebar),
  revealUiMessage(MessageFromTo.fromContentToSidebar),
  ;

  const InIdeMessageType(this.messageFromTo);

  final MessageFromTo messageFromTo;
}

// Rename carefully, because some names are hard coded in node.
// Should we use proto?
enum MessageFromTo {
  fromContentToSidebar,
  fromSidebarToIde,
}

class _JsonFields {
  static const String type = 'type';
  static const String fromTo = 'fromTo';
  static const String prompt = 'prompt';
  static const String data = 'data';
  static const String ui = 'ui';
  static const String numberOfOptions = 'numberOfOptions';
  static const String openOnSide = 'openOnSide';
}

sealed class InIdeMessage {
  InIdeMessage(this.type);

  final InIdeMessageType type;

  Map<String, dynamic> _concreteToJson();

  @nonVirtual
  Map<String, dynamic> toJson() {
    _assertType();
    final json = _concreteToJson();
    json[_JsonFields.type] = type.name;
    json[_JsonFields.fromTo] = type.messageFromTo.name;
    return json;
  }

  void _assertType() {
    assert(type.name.toLowerCase() == runtimeType.toString().toLowerCase());
  }

  String jsonEncode() => convert.jsonEncode(toJson());
}

InIdeMessage messageFromJson(String jsonString) {
  var json = convert.jsonDecode(jsonString) as Map<String, dynamic>;

  // If the message is wrapped in a data field, unwrap it.
  // Different sources wrap the message in different ways.
  if (json[_JsonFields.data] != null) {
    json = json[_JsonFields.data] as Map<String, dynamic>;
  }
  final typeString = json[_JsonFields.type] as String;
  final type = InIdeMessageType.values.byName(typeString);

  switch (type) {
    case InIdeMessageType.generateUiMessage:
      return GenerateUiMessage(
        prompt: json[_JsonFields.prompt] as String,
        numberOfOptions: json[_JsonFields.numberOfOptions] as int,
        openOnSide: json[_JsonFields.openOnSide] as bool,
      );

    case InIdeMessageType.revealPromptMessage:
      return RevealPromptMessage(
        prompt: json[_JsonFields.prompt] as String,
      );

    case InIdeMessageType.experimentalWindowMessage:
      return ExperimentalWindowMessage();

    case InIdeMessageType.revealUiMessage:
      return RevealUiMessage(
        ui: GenUi.fromJson(json[_JsonFields.ui] as Map<String, dynamic>),
      );
  }
}

class GenerateUiMessage extends InIdeMessage {
  GenerateUiMessage({
    required this.prompt,
    required this.numberOfOptions,
    required this.openOnSide,
  }) : super(InIdeMessageType.generateUiMessage);

  final String prompt;
  final int numberOfOptions;
  final bool openOnSide;

  @override
  Map<String, dynamic> _concreteToJson() => {
        _JsonFields.prompt: prompt,
        _JsonFields.numberOfOptions: numberOfOptions,
        _JsonFields.openOnSide: openOnSide,
      };
}

class ExperimentalWindowMessage extends InIdeMessage {
  ExperimentalWindowMessage()
      : super(InIdeMessageType.experimentalWindowMessage);

  @override
  Map<String, dynamic> _concreteToJson() => {};
}

class RevealPromptMessage extends InIdeMessage {
  RevealPromptMessage({required this.prompt})
      : super(InIdeMessageType.revealPromptMessage);

  final String prompt;

  @override
  Map<String, dynamic> _concreteToJson() => {
        _JsonFields.type: InIdeMessageType.revealPromptMessage.name,
        _JsonFields.prompt: prompt,
      };
}

class RevealUiMessage extends InIdeMessage {
  RevealUiMessage({required this.ui}) : super(InIdeMessageType.revealUiMessage);

  final GenUi ui;

  @override
  Map<String, dynamic> _concreteToJson() => {
        _JsonFields.type: InIdeMessageType.revealUiMessage.name,
        _JsonFields.ui: ui.toJson(),
      };
}
