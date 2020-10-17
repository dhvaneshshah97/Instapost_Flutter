import 'package:InstaPost/screens/add_posts.dart';
import 'package:InstaPost/screens/auth_screen.dart';
import 'package:InstaPost/screens/list_of_hashtags.dart';
import 'package:InstaPost/screens/users_by_nickname.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Welcome back!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.plus),
            title: Text(
              'Add Post',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, AddPost.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.users),
            title: Text(
              'Find Users by Nicknames',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UsersByNickname.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.hashtag),
            title: Text(
              'All Hashtags',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ListOfHashtags.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.arrowAltCircleLeft),
            title: Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: _logOut,
          ),
        ],
      ),
    );
  }
}
