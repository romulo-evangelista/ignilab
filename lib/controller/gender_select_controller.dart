import 'package:flutter/foundation.dart';

class GenderSelectController extends ChangeNotifier {
  String selected;

  changeGender(String gender) {
    this.selected = gender;
    this.notifyListeners();
  }
}
