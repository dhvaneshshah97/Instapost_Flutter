import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetAllHashtagsProvider with ChangeNotifier {
  List posts = [];

  Future<List> getAllHashtags() async {
    const url = "https://bismarck.sdsu.edu/api/instapost-query/hashtags";
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final responseData = jsonDecode(response.body);
    // print(responseData['hashtags']);
    return responseData['hashtags'];
  }

  Future<List> getPosts(String hashtag) async {
    this.posts.clear();
    String newhashtag = hashtag.replaceAll('#', '%23');
    print(newhashtag);
    final url =
        "https://bismarck.sdsu.edu/api/instapost-query/hashtags-post-ids?hashtag=$newhashtag";
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final responseData = jsonDecode(response.body);
      print(responseData);
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
        print(this.posts[0]['post']['text']);
        print(this.posts);
        return this.posts;
      }
      return this.posts;
    } catch (error) {
      throw error;
    }
  }
}
