import 'dart:convert' as convert;

abstract class InIdeMessage {
  Map<String, dynamic> toJson();

  String jsonEncode() => convert.jsonEncode(toJson());
}

// Do not rename, because some names are hard coded in node.
// Should we use proto?
enum _InIdeMessageType {
  generateUiMessage,
  revealMessage,
  experimentalWindowMessage,
}

class _JsonFields {
  static const String type = 'type';
  static const String prompt = 'prompt';
  static const String data = 'data';

  static const String numberOfOptions = 'numberOfOptions';
  static const String openOnSide = 'openOnSide';
}

InIdeMessage messageFromJson(String jsonString) {
  var json = convert.jsonDecode(jsonString) as Map<String, dynamic>;
  if (json[_JsonFields.data] != null) {
    json = json[_JsonFields.data] as Map<String, dynamic>;
  }
  final typeString = json[_JsonFields.type] as String;
  final type = _InIdeMessageType.values.byName(typeString);
  switch (type) {
    case _InIdeMessageType.generateUiMessage:
      return GenerateUiMessage(
        prompt: json[_JsonFields.prompt] as String,
        numberOfOptions: json[_JsonFields.numberOfOptions] as int,
        openOnSide: json[_JsonFields.openOnSide] as bool,
      );
    case _InIdeMessageType.revealMessage:
      return RevealMessage(json[_JsonFields.prompt] as String);
    case _InIdeMessageType.experimentalWindowMessage:
      return ExperimentalWindowMessage();
  }
}

class GenerateUiMessage extends InIdeMessage {
  GenerateUiMessage({
    required this.prompt,
    required this.numberOfOptions,
    required this.openOnSide,
  });

  final String prompt;
  final int numberOfOptions;
  final bool openOnSide;

  @override
  Map<String, dynamic> toJson() => {
        _JsonFields.type: _InIdeMessageType.generateUiMessage.name,
        _JsonFields.prompt: prompt,
        _JsonFields.numberOfOptions: numberOfOptions,
        _JsonFields.openOnSide: openOnSide,
      };
}

class ExperimentalWindowMessage extends InIdeMessage {
  ExperimentalWindowMessage();

  @override
  Map<String, dynamic> toJson() => {
        _JsonFields.type: _InIdeMessageType.experimentalWindowMessage.name,
      };
}

class RevealMessage extends InIdeMessage {
  RevealMessage(this.prompt);

  final String prompt;

  @override
  Map<String, dynamic> toJson() => {
        _JsonFields.type: _InIdeMessageType.revealMessage.name,
        _JsonFields.prompt: prompt,
      };
}
