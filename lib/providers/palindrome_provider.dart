import 'package:flutter/material.dart';

class PalindromeProvider extends ChangeNotifier {
  bool _isPalindrome = false;

  bool get isPalindrome => _isPalindrome;

  void checkPalindrome(String text) {
    String cleanText = text.toLowerCase().replaceAll(' ', '');
    String reversedText = cleanText.split('').reversed.join('');
    _isPalindrome = cleanText == reversedText;
    notifyListeners();
  }
}
