import 'package:InstaPost/screens/auth_screen.dart';
import 'package:InstaPost/screens/home_screen.dart';
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
  String _name = '';
  String _email = '';

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<String> _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('firstname');
    String email = prefs.getString('email');
    setState(() {
      _name = name;
      _email = email;
    });
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          FutureBuilder(
              future: _getUserDetails(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return UserAccountsDrawerHeader(
                    accountName: Text(_name),
                    accountEmail: Text(_email),
                    currentAccountPicture: CircleAvatar(
                      child: Text(
                        _name[0].toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.red[400],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
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
              Navigator.of(context)
                  .pushReplacementNamed(ListOfHashtags.routeName);
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
