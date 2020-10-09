import 'package:InstaPost/providers/fetch_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

class ShowPosts extends StatefulWidget {
  final nickname;

  ShowPosts(this.nickname);

  @override
  _ShowPostsState createState() => _ShowPostsState();
}

class _ShowPostsState extends State<ShowPosts> {
  List _posts = [];
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    _getPosts();
    // print(_posts);
  }

  Future<void> _getPosts() async {
    return this._memoizer.runOnce(() async {
      List posts = await Provider.of<FetchPosts>(context, listen: false)
          .getPosts(this.widget.nickname);
      setState(() {
        _posts = posts;
      });
      print(_posts);
      return _posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPosts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length > 0
              ? ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) => Container(
                    height: 100,
                    child: Card(
                      child: ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(_posts[index]['post']['text']),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                  "Sorry, This User has no Posts",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
