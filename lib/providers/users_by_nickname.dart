import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersByNicknameProvider with ChangeNotifier {
  Future<List> getAllUsers() async {
    const url = "https://bismarck.sdsu.edu/api/instapost-query/nicknames";
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final responseData = jsonDecode(response.body);
    return responseData['nicknames'];
  }
}
