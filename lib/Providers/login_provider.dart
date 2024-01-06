import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  bool? isUserLoggedIn;

  Future<void> saveLoginInfoInSharedPreferences({
    required bool isAdminLoggedIn,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isAdminLoggedIn);
    isUserLoggedIn = true;
    notifyListeners();
  }

  Future<void> getLoginInfoFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(seconds: 2));
    isUserLoggedIn = prefs.getBool('isLoggedIn');
    notifyListeners();
  }

  Future<void> logOutUserStoreInfoInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    isUserLoggedIn = false;
    notifyListeners();
  }
}
