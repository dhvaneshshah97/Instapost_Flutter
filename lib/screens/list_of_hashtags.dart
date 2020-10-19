import 'package:InstaPost/providers/get_all_hashtags.dart';
import 'package:InstaPost/screens/hashtags_related_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import 'package:async/async.dart';

class ListOfHashtags extends StatefulWidget {
  static const routeName = '/listofhashtags';

  @override
  _ListOfHashtagsState createState() => _ListOfHashtagsState();
}

class _ListOfHashtagsState extends State<ListOfHashtags> {
  List _hashtags = [];
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    _getAllHashtags();
  }

  // This method will fetch all hashtags from provider and store in _hashtags list
  Future<void> _getAllHashtags() async {
    return this._memoizer.runOnce(() async {
      List hashtags =
          await Provider.of<GetAllHashtagsProvider>(context, listen: false)
              .getAllHashtags();
      setState(() {
        _hashtags = hashtags;
      });
      return _hashtags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('List of Hashtags'),
        ),
        body: FutureBuilder<dynamic>(
          future: _getAllHashtags(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: _hashtags.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HashtagRelatedPosts(_hashtags[index]))),
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                      ),
                    ),
                    title: Container(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        _hashtags[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Could not fetch hashtags! Try again later',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
