import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchPosts with ChangeNotifier {
  List posts = [];

  // There are two sub-parts of below method.
  Future<List> getPosts(String nickname) async {
    this.posts.clear();
    try {
      final url =
          "https://bismarck.sdsu.edu/api/instapost-query/nickname-post-ids?nickname=$nickname";
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final responseData = jsonDecode(response.body);
      if (responseData['ids'].length > 0) {
        for (int i = 0; i < responseData['ids'].length; i++) {
          var id = responseData['ids'][i];
          final url1 =
              "https://bismarck.sdsu.edu/api/instapost-query/post?post-id=$id";
          final response1 = await http.get(
            url1,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          final responseDatat1 = jsonDecode(response1.body);
          this.posts.add(responseDatat1);
        }
        return this.posts;
      }
      return this.posts;
    } catch (error) {
      throw error;
    }
  }
}
