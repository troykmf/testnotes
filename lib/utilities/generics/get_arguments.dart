import 'package:flutter/material.dart' show BuildContext, ModalRoute;

/// basically this says that if it could grab any arguments from the modalRoute
/// and its argument and if the argument is of its type that your asking the
/// functoin in line 10, then return the argment else just flow to line 15 which
/// is to return null
extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
