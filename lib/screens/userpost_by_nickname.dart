import 'package:InstaPost/widgets/show_posts.dart';
import 'package:flutter/material.dart';

class UserPostByNickname extends StatelessWidget {
  final nickname;
  UserPostByNickname(this.nickname);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${this.nickname}\'s All Posts'),
      ),
      body: ShowPosts(this.nickname, 'nickname'),
    );
  }
}
