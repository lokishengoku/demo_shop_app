import 'dart:async';

import 'package:flutter/widgets.dart';
import 'dart:convert';

import 'package:demo_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _token = '';
  dynamic _expireDate;
  String _userId = '';
  dynamic _authTimer;

  bool get isAuth {
    return token.length > 0;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token.length > 0) {
      return _token;
    }
    return '';
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    try {
      Uri url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${dotenv.get('FIREBASE_API_KEY')}');
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();

      final SharedPreferences prefs = await _prefs;
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expireDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<bool> tryAutoLogin() async {
    final SharedPreferences prefs = await _prefs;
    if (!prefs.containsKey('userData')) {
      return false;
    }
    print(prefs.getString('userData'));
    final extractedUserData = json.decode(prefs.getString('userData') ?? '');
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'] ?? '');

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'] ?? '';
    _userId = extractedUserData['userId'] ?? '';
    _expireDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  void logout() async {
    _token = '';
    _userId = '';
    _expireDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    final prefs = await _prefs;
    prefs.clear();
    // prefs.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds();
    _authTimer = Timer(
      Duration(seconds: timeToExpiry),
      logout,
    );
  }
}
