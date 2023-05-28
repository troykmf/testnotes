import 'package:flutter/material.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close; // for clsoing the screen
  final UpdateLoadingScreen update; // for updating the screen

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
