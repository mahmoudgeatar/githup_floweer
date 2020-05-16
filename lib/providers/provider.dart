import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:github/models/users.dart';
import 'package:github/requests/getRequest.dart';

class UserProvider with ChangeNotifier {
  User user;

  String errorMessage;

  bool loading = false;

  Future<bool> fetchUser(username) async {
    setLoading(true);
    await Github(username).fetchUser().then((data) {
      if (data.statusCode == 200) {
        setLoading(false);
        setUser(User.fromJson(json.decode(data.body)));
      } else {
        print(data.body);
        Map<String, dynamic> result = json.decode(data.body);
        setMessage(result['meesage']);
      }
    });
    return isUser();
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  void setUser(value) {
    user = value;
  }

  User gerUser() {
    return user;
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool isUser() {
    return user != null ? true : false;
  }
}
