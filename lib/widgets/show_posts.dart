import 'package:InstaPost/providers/fetch_post.dart';
import 'package:InstaPost/providers/get_all_hashtags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

class ShowPosts extends StatefulWidget {
  final queryString;
  final whichScreen;
  ShowPosts(this.queryString, this.whichScreen);

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

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Oops!'),
              content: Text(message),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.pop(context);
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  Future<void> _getPosts() async {
    return this._memoizer.runOnce(() async {
      try {
        if (this.widget.whichScreen == 'nickname') {
          List posts = await Provider.of<FetchPosts>(context, listen: false)
              .getPosts(this.widget.queryString);
          setState(() {
            _posts = posts;
          });
          print(_posts);
          return _posts;
        } else if (this.widget.whichScreen == 'hashtag') {
          List posts =
              await Provider.of<GetAllHashtagsProvider>(context, listen: false)
                  .getPosts(this.widget.queryString);
          setState(() {
            _posts = posts;
          });
          // print(_posts);
          return _posts;
        }
      } catch (error) {
        const errorMessage = 'Something went wrong, try again later..!';
        _showErrorDialog(errorMessage);
      }
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
                    height: 150,
                    child: Card(
                        child: Column(
                      children: [
                        ListTile(
                          leading: Text('${index + 1}'),
                          title: Text(_posts[index]['post']['text']),
                        ),
                        Container(
                          // width: 140,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: 'Your Comments'),
                          ),
                        )
                      ],
                    )),
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
