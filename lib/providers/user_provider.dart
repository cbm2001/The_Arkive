import 'package:first_app/services/crud/user_service.dart';
import 'package:flutter/widgets.dart';
import '../models/user.dart';
//import '/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User _user;
  final UserService _user_service = UserService();

  User get getUser =>
      _user; // since _user is a private variable, we're using a getter to access it outside this class.

  Future<void> refreshUser() async {
    User user = await _user_service.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
