import 'package:flutter/foundation.dart';

class InvalidLoginController extends ChangeNotifier {
  bool invalid = false;

  changeInvalid(bool invalid) {
    this.invalid = true;
    this.notifyListeners();
  }
}
