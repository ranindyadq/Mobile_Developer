import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  String _userName = '';
  String _selectedUserName = 'Selected User Name';

  String get userName => _userName;
  String get selectedUserName => _selectedUserName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setSelectedUserName(String name) {
    _selectedUserName = name;
    notifyListeners();
  }
}
