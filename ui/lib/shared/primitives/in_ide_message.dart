import 'dart:convert' as convert;

abstract class InIdeMessage {
  Map<String, dynamic> toJson();

  String jsonEncode() => convert.jsonEncode(toJson());
}

// Do not rename, because the names are hard coded in node.
// Should we use proto?
enum _InIdeMessageType {
  generateUi,
  reveal,
}

class _JsonFields {
  static const String type = 'type';
  static const String prompt = 'prompt';
}

InIdeMessage fromJson(Map<String, dynamic> json) {
  final typeString = json[_JsonFields.type] as String;
  final type = _InIdeMessageType.values.byName(typeString);
  switch (type) {
    case _InIdeMessageType.generateUi:
      return GenerateUiMessage(json[_JsonFields.prompt] as String);
    case _InIdeMessageType.reveal:
      return RevealMessage(json[_JsonFields.prompt] as String);
  }
}

class GenerateUiMessage extends InIdeMessage {
  GenerateUiMessage(this.prompt);

  final String prompt;

  @override
  Map<String, dynamic> toJson() => {
        _JsonFields.type: _InIdeMessageType.generateUi.name,
        _JsonFields.prompt: prompt,
      };
}

class RevealMessage extends InIdeMessage {
  RevealMessage(this.prompt);

  final String prompt;

  @override
  Map<String, dynamic> toJson() => {
        _JsonFields.type: _InIdeMessageType.reveal.name,
        _JsonFields.prompt: prompt,
      };
}
