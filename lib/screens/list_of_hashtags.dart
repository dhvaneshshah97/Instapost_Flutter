import 'package:InstaPost/providers/get_all_hashtags.dart';
import 'package:InstaPost/screens/hashtags_related_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

class ListOfHashtags extends StatefulWidget {
  static const routeName = '/listofhashtags';

  @override
  _ListOfHashtagsState createState() => _ListOfHashtagsState();
}

class _ListOfHashtagsState extends State<ListOfHashtags> {
  List _hashtags = [];

  @override
  void initState() {
    super.initState();
    _getAllHashtags();
  }

  // This method will fetch all hashtags from provider and store in _hashtags list
  Future<void> _getAllHashtags() async {
    List hashtags =
        await Provider.of<GetAllHashtagsProvider>(context, listen: false)
            .getAllHashtags();
    setState(() {
      _hashtags = hashtags;
    });
    return _hashtags;
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
                    leading: Text(
                      '${index + 1}',
                      style: TextStyle(),
                    ),
                    title: Text(_hashtags[index]),
                    trailing: FlatButton(
                        child: Text("See related Posts"),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HashtagRelatedPosts(_hashtags[index])))),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
