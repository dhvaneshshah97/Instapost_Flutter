import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/http_exception.dart';

class AddRatings with ChangeNotifier {
  Future<void> addRatings(int rating, int postid) async {
    const url = "https://bismarck.sdsu.edu/api/instapost-upload/rating";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    String password = prefs.getString('password');
    try {
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "email": email,
            "password": password,
            "rating": rating,
            "post-id": postid,
          }));

      print(jsonDecode(response.body));
      // final responseData = jsonDecode(response.body);
      // if (responseData['result'] == 'fail') {
      //   throw HttpException(responseData['errors']);
      // }
    } catch (error) {
      throw error;
    }
  }
}
