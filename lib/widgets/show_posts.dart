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
              ? Container(
                  child: ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 0.0),
                      child: Card(
                          child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: Text((index + 1).toString()),
                              ),
                              title: Text(
                                _posts[index]['post']['text'],
                                style: TextStyle(
                                  fontSize: 23.0,
                                ),
                              ),
                              subtitle:
                                  Text(_posts[index]['post']['hashtags'][0]),
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total ratings: ${_posts[index]['post']['ratings-count']}',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(() {
                                      if (_posts[index]['post']
                                              ['ratings-average'] ==
                                          -1) {
                                        _posts[index]['post']
                                            ['ratings-average'] = 0;
                                        return 'Average rating: ${_posts[index]['post']['ratings-average']}';
                                      } else {
                                        return 'Average rating: ${_posts[index]['post']['ratings-average']}';
                                      }
                                    }()),
                                  ],
                                )),
                            // Container(
                            //     child:
                            // ),
                            Container(
                              // width: 140,
                              child: TextField(
                                decoration:
                                    InputDecoration(labelText: 'Your Comments'),
                              ),
                            )
                          ],
                        ),
                      )),
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
