import 'package:InstaPost/providers/add_comments.dart';
import 'package:InstaPost/providers/add_ratings.dart';
import 'package:InstaPost/providers/fetch_post.dart';
import 'package:InstaPost/providers/get_all_hashtags.dart';
import 'package:InstaPost/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import 'package:rating_bar/rating_bar.dart' as RB;

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
  Map<int, String> _inputs = {};
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _getPosts();
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
          return _posts;
        } else if (this.widget.whichScreen == 'hashtag') {
          List posts =
              await Provider.of<GetAllHashtagsProvider>(context, listen: false)
                  .getPosts(this.widget.queryString);
          setState(() {
            _posts = posts;
          });
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
      if (this.widget.whichScreen == 'nickname') {
        List posts = await Provider.of<FetchPosts>(context, listen: false)
            .getPosts(this.widget.queryString);
        setState(() {
          _posts = posts;
        });
      } else if (this.widget.whichScreen == 'hashtag') {
        List posts =
            await Provider.of<GetAllHashtagsProvider>(context, listen: false)
                .getPosts(this.widget.queryString);
        setState(() {
          _posts = posts;
        });
      }
      _inputs.clear();
    }
  }

  Future<void> _addsRating(int postid) async {
    int _ratingForAPI = _rating.toInt();
    await Provider.of<AddRatings>(context, listen: false)
        .addRatings(_ratingForAPI, postid);
    if (this.widget.whichScreen == 'nickname') {
      List posts = await Provider.of<FetchPosts>(context, listen: false)
          .getPosts(this.widget.queryString);
      setState(() {
        _posts = posts;
      });
    } else if (this.widget.whichScreen == 'hashtag') {
      List posts =
          await Provider.of<GetAllHashtagsProvider>(context, listen: false)
              .getPosts(this.widget.queryString);
      setState(() {
        _posts = posts;
      });
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _posts[index]['post']['image'] != -1
                                ? Container(
                                    child: FutureBuilder(
                                      future: Provider.of<APIImageProvider>(
                                              context,
                                              listen: false)
                                          .getAnImage(
                                              _posts[index]['post']['image']),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return Card(
                                            child: Image.memory(
                                              snapshot.data,
                                              fit: BoxFit.cover,
                                              // height: 400,
                                              width: double.infinity,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return SizedBox();
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                : Container(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      contentPadding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      leading: CircleAvatar(
                                        child: Text((index + 1).toString()),
                                      ),
                                      title: Text(
                                        _posts[index]['post']['text'],
                                        style: TextStyle(
                                          fontSize: 23.0,
                                        ),
                                      ),
                                      subtitle: () {
                                        return Text(
                                          _posts[index]['post']['hashtags']
                                              .join(' '),
                                        );
                                      }()),
                                  Divider(),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Total ratings: ${_posts[index]['post']['ratings-count']}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Your Ratings',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                () {
                                                  if (_posts[index]['post']
                                                          ['ratings-average'] ==
                                                      -1) {
                                                    _posts[index]['post']
                                                        ['ratings-average'] = 0;
                                                    return 'Average rating: ${_posts[index]['post']['ratings-average']}';
                                                  } else {
                                                    return 'Average rating: ${_posts[index]['post']['ratings-average'].toStringAsFixed(1)}';
                                                  }
                                                }(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              RB.RatingBar(
                                                size: 23,
                                                initialRating: 0,
                                                emptyIcon: Icons.star_border,
                                                maxRating: 5,
                                                filledIcon: Icons.star,
                                                isHalfAllowed: false,
                                                filledColor: Colors.amber,
                                                onRatingChanged: (rating) =>
                                                    _rating = rating,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () => _addsRating(
                                                    _posts[index]['post']
                                                        ['id']),
                                                child: CircleAvatar(
                                                  maxRadius: 13.0,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 17,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              RB.RatingBar.readOnly(
                                                size: 23,
                                                initialRating: double.parse(
                                                    _posts[index]['post']
                                                            ['ratings-average']
                                                        .toString()),
                                                isHalfAllowed: true,
                                                halfFilledIcon: Icons.star_half,
                                                filledIcon: Icons.star,
                                                emptyIcon: Icons.star_border,
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                  Divider(),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 12),
                                    child: Text(
                                      'Comments',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _posts[index]['post']
                                              ['comments']
                                          .map<Widget>((comment) => Container(
                                                child: Text(
                                                  '- $comment',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
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
                                        labelStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
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
                                      'Add',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Theme.of(context).primaryColor,
                                  )
                                ],
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
