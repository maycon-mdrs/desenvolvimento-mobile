import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class Auth with ChangeNotifier {
  String? _userEmail;
  String? _userId;

  bool get isAuth {
    return _userId != null;
  }

  String? get userEmail {
    return _userEmail;
  }

  bool login(String email, String password) {
    if (email == 'maycon@gmail.com' && password == '123') {
      _userEmail = email;
      _userId = 'user_id_simulado'; 
      return true; 
    } else {
      return false; 
    }
  }

  void logout() {
    _userEmail = null;
    _userId = null;
    notifyListeners();
  }
}
