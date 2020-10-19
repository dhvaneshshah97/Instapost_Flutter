import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetAllHashtagsProvider with ChangeNotifier {
  List _posts = [];

  Future<List> getAllHashtags() async {
    const url = "https://bismarck.sdsu.edu/api/instapost-query/hashtags";
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final responseData = jsonDecode(response.body);
    return responseData['hashtags'];
  }

  Future<List> getPosts(String hashtag) async {
    this._posts.clear();
    String newhashtag = hashtag.replaceAll('#', '%23');
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
      // if 'ids' array have any post-ids then only we will fetch posts for the hashtag
      if (responseData['ids'].length > 0) {
        for (int i = 0; i < responseData['ids'].length; i++) {
          var id = responseData['ids'][i];
          final fetchPostUrl =
              "https://bismarck.sdsu.edu/api/instapost-query/post?post-id=$id";
          final rawResponsePosts = await http.get(
            fetchPostUrl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          final responsePosts = jsonDecode(rawResponsePosts.body);
          this._posts.add(responsePosts);
        }
        return this._posts;
      }
      return this._posts;
    } catch (error) {
      throw error;
    }
  }
}
