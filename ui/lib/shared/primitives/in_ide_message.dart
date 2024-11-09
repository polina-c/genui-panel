import 'dart:convert' as convert;

abstract class InIdeMessage {
  Map<String, dynamic> toJson();

  String jsonEncode() => convert.jsonEncode(toJson());
}

enum _OutIdeMessageType {
  // Do not rename, because the name is hard coded in node.
  // Should we use proto?
  generateContent,
}

class _JsonFields {
  static const String type = 'type';
  static const String prompt = 'prompt';
}

InIdeMessage fromJson(Map<String, dynamic> json) {
  final typeString = json[_JsonFields.type] as String;
  final type = _OutIdeMessageType.values.byName(typeString);
  switch (type) {
    case _OutIdeMessageType.generateContent:
      return GenerateContentMessage(json[_JsonFields.prompt] as String);
  }
}

class GenerateContentMessage extends InIdeMessage {
  GenerateContentMessage(this.prompt);

  final String prompt;

  @override
  Map<String, dynamic> toJson() => {
        _JsonFields.type: _OutIdeMessageType.generateContent.name,
        _JsonFields.prompt: prompt,
      };
}
