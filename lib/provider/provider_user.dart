import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _email = "";
  String _password = "";
  String _name = "";
  double _distPrefer = 0;
  double _costPrefer = 0;
  bool _canMechanical = true;
  bool _canNarrow = true;
  String _token = "";

  String get email => _email;
  String get password => _password;
  String get name => _name;
  double get distPrefer => _distPrefer;
  double get costPrefer => _costPrefer;
  bool get canMechanical => _canMechanical;
  bool get canNarrow => _canNarrow;
  String get token => _token;

  set email(String inputEmail) {
    _email = inputEmail;
    notifyListeners();
  }

  set password(String inputPassword) {
    _password = inputPassword;
    notifyListeners();
  }

  set name(String inputName) {
    _name = inputName;
    notifyListeners();
  }

  set distPrefer(double inputDistPrefer) {
    _distPrefer = inputDistPrefer;
    notifyListeners();
  }

  set costPrefer(double inputCostPrefer) {
    _costPrefer = inputCostPrefer;
    notifyListeners();
  }

  set canMechanical(bool inputCanMechanical) {
    _canMechanical = inputCanMechanical;
    notifyListeners();
  }

  set canNarrow(bool inputCanNarrow) {
    _canNarrow = inputCanNarrow;
    notifyListeners();
  }

  set token(String inputToken) {
    _token = inputToken;
    notifyListeners();
  }
}
