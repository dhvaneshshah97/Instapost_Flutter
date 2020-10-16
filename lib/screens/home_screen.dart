import 'package:InstaPost/screens/add_posts.dart';

import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'InstaPost',
          style: TextStyle(
            letterSpacing: 1.0,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 5),
              child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushNamed(context, AddPost.routeName);
                  })),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
