import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonsProvider extends ChangeNotifier {
  bool _showButtons = true;

  bool get showButtons => _showButtons;

  ButtonsProvider() {
    _loadFromPrefs();
  }

  void toggleButtons(bool value) {
    _showButtons = !value;
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _showButtons = prefs.getBool('showButtons') ?? true;
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showButtons', _showButtons);
  }
}
