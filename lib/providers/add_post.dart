import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/http_exception.dart';

class AddPostProvider with ChangeNotifier {
  Future<void> addPost(
      String description, String hashtags, String encodedimage) async {
    List listofhashtags = hashtags.split(' ');

    const url = "https://bismarck.sdsu.edu/api/instapost-upload/post";
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
            "text": description,
            "hashtags": listofhashtags,
          }));

      print(jsonDecode(response.body));
      final responseData = jsonDecode(response.body);
      if (responseData['result'] == 'fail') {
        throw HttpException(responseData['errors']);
      }

      // if there is no image, then no point of sending it to server
      if (encodedimage != null) {
        const url_image =
            "https://bismarck.sdsu.edu/api/instapost-upload/image";

        final responseimage = await http.post(url_image,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "email": email,
              "password": password,
              "image": encodedimage,
              "post-id": responseData['id'],
            }));
        print(jsonDecode(responseimage.body));
      }
    } catch (error) {
      throw error;
    }
  }
}
