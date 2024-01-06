import 'package:flutter/material.dart';

class ActiveIndexProvider extends ChangeNotifier {
  ActiveIndexProvider({required this.activeIndex});
  int activeIndex;
  String categoryName = '';
  void setActiveIndex(int index) {
    if (activeIndex == index) {
      activeIndex = -1;
      categoryName = '';
    } else {
      activeIndex = index;
    }

    notifyListeners();
  }

  void setName(String name) {
    categoryName = name;
    notifyListeners();
  }
}
