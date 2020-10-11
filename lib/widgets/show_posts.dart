import 'package:InstaPost/providers/add_comments.dart';
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
  // String _comment = '';
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  Map<int, String> _inputs = {};
  // bool _validate = false;

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

  Future<void> _addsComment(String comment, int postid) async {
    if (_inputs.isNotEmpty) {
      await Provider.of<AddComments>(context, listen: false)
          .addCommets(comment, postid);
      List posts =
          await Provider.of<GetAllHashtagsProvider>(context, listen: false)
              .getPosts(this.widget.queryString);
      setState(() {
        _posts = posts;
      });
      _inputs.clear();
    }
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
                            Divider(),
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
                            Divider(),
                            Text(
                              'Comments',
                              style: TextStyle(fontSize: 15),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _posts[index]['post']['comments']
                                    .map<Widget>((comment) => Container(
                                          child: Text('- $comment'),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Divider(),
                            Container(
                              // width: 140,
                              child: TextField(
                                controller: TextEditingController(),
                                decoration: InputDecoration(
                                  labelText: 'Write a comment...',
                                  // errorText: _validate
                                  //     ? 'Please enter your comment first'
                                ),
                                onChanged: (value) {
                                  _inputs[_posts[index]['post']['id']] =
                                      value.toString();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            RaisedButton(
                              onPressed: () => _addsComment(
                                  _inputs[_posts[index]['post']['id']],
                                  _posts[index]['post']['id']),
                              // _addsComment(_posts[index]['post']['id']),
                              child: Text(
                                'Done',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Theme.of(context).primaryColor,
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
