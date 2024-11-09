class PostMessageEvent {
  PostMessageEvent({
    required this.origin,
    required this.data,
  });

  final String origin;
  final Object? data;
}
