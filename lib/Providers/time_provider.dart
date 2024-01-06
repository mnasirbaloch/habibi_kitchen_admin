import 'package:flutter/material.dart';
import 'dart:async';

class MyTimeProvider with ChangeNotifier {
  String _currentTime = '';

  // Getter for the current time
  String get currentTime => _currentTime;

  MyTimeProvider() {
    // Call the _updateTime function immediately
    _updateTime();

    // Start a repeating timer that calls _updateTime every minute
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    // Get the current time
    DateTime now = DateTime.now();

    // Format the time as Hour:Minutes AM/PM
    String formattedTime =
        '${_formatHour(now.hour)}:${_formatMinute(now.minute)} ${_getMeridian(now.hour)}';

    // Update the currentTime with the formatted time
    _currentTime = formattedTime;

    // Notify all listeners that the time has been updated
    notifyListeners();
  }

  String _formatHour(int hour) {
    int hour12 = (hour > 12) ? hour - 12 : hour;
    return hour12.toString().padLeft(2, '0');
  }

  String _formatMinute(int minute) {
    return minute.toString().padLeft(2, '0');
  }

  String _getMeridian(int hour) {
    return (hour >= 12) ? 'PM' : 'AM';
  }
}
