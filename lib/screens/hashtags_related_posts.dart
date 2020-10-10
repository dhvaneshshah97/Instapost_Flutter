import 'package:InstaPost/widgets/show_posts.dart';
import 'package:flutter/material.dart';

class HashtagRelatedPosts extends StatelessWidget {
  final hashtag;
  HashtagRelatedPosts(this.hashtag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts related to ${this.hashtag}'),
      ),
      body: ShowPosts(this.hashtag, 'hashtag'),
    );
  }
}
