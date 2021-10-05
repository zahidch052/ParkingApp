import 'package:flutter/material.dart';

class AddParkingScreenViewModel extends ChangeNotifier {
  int ratingValue = 1;
  String errorName = '';
  String errorDescription = '';

  void setRating(int value) {
    this.ratingValue = value;
    notifyListeners();
  }

  void setErrorName(String value) {
    errorName = value;
    notifyListeners();
  }

  void setErrorDescription(String value) {
    errorDescription = value;
    notifyListeners();
  }
}
