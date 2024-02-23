import 'package:flutter/foundation.dart';

class StoreProvider extends ChangeNotifier {
  int _selectedTab = 0;
  int _selectedTranscriptId = 1;

  int get selectedTab => _selectedTab;
  int get selectedTranscriptId => _selectedTranscriptId;

  void updateSelectedTab(int newTab) {
    _selectedTab = newTab;
    notifyListeners();
  }

  void updateSelectedTranscriptId(int newValue) {
    _selectedTranscriptId = newValue;
    notifyListeners();
  }
}
