import 'package:flutter/foundation.dart';

// Provider class to display error messages on the Signup Screen
class SignupProvider extends ChangeNotifier {
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
