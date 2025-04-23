import 'package:flutter/material.dart';

class AuthClientProvider extends ChangeNotifier {
  dynamic _authClient;

  dynamic get authClient => _authClient;

  void setAuthClient(dynamic client) {
    _authClient = client;
    notifyListeners();
  }
}
