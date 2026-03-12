import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = "Jennie";
  String _email = "jenniekim@email.com";

  String get name => _name;
  String get email => _email;

  get imagePath => null;

  void updateProfile(String newName, String newEmail, imagePath) {
    _name = newName;
    _email = newEmail;
    notifyListeners(); // This triggers both Home and Account pages to rebuild
  }
}