import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  Future<void> signup(String firstname, String lastname, String nickname,
      String email, String password) async {
    const url = "https://bismarck.sdsu.edu/api/instapost-upload/newuser";
    try {
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "firstname": firstname,
            "lastname": lastname,
            "nickname": nickname,
            "email": email,
            "password": password,
          }));

      final responseData = jsonDecode(response.body);
      if (responseData['result'] == 'fail') {
        throw HttpException(responseData['errors']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final url =
        "https://bismarck.sdsu.edu/api/instapost-query/authenticate?email=$email&password=$password";
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final responseData = jsonDecode(response.body);
      if (responseData['result'] == false) {
        throw HttpException('Email and Password do not match!');
      }
    } catch (error) {
      throw error;
    }
  }
}
