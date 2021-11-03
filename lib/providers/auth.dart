import 'dart:convert';

import 'package:demo_shop_app/models/http_exception.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  String _token = '';
  DateTime _expireDate = DateTime.now();
  String _userId = '';

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    try {
      Uri url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=[API_KEY]');
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
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
}
