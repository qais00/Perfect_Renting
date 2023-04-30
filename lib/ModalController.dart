import 'package:flutter/foundation.dart' show immutable;

typedef CloseModal = bool Function();
typedef UpdateModal = bool Function(String text);

@immutable
class ModalController {
  final CloseModal close;
  final UpdateModal update;

  const ModalController({
    required this.close,
    required this.update,
  });
}