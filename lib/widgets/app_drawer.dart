import 'package:InstaPost/screens/auth_screen.dart';
import 'package:InstaPost/screens/home_screen.dart';
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
            title: Text('Hi there..!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Homescreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.users),
            title: Text('Find Users by Nicknames'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UsersByNickname.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.hashtag),
            title: Text('All Hashtags'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.arrowAltCircleLeft),
            title: Text('Log Out'),
            onTap: _logOut,
          ),
        ],
      ),
    );
  }
}
