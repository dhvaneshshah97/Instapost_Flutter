import 'package:InstaPost/screens/userpost_by_nickname.dart';
import 'package:InstaPost/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users_by_nickname.dart';

class UsersByNickname extends StatefulWidget {
  static const routeName = '/usersbynickname';

  @override
  _UsersByNicknameState createState() => _UsersByNicknameState();
}

class _UsersByNicknameState extends State<UsersByNickname> {
  List _nicknames = [];

  @override
  void initState() {
    super.initState();
    _getUsersByNickname();
  }

  // This method will fetch all nicknames from provider and store in _nicknames list
  Future<void> _getUsersByNickname() async {
    List nicknames =
        await Provider.of<UsersByNicknameProvider>(context, listen: false)
            .getAllUsers();
    setState(() {
      _nicknames = nicknames;
    });
    return nicknames;
  }

  _goToUserPostByNicknameScreen(nickname) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserPostByNickname(nickname)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('List of Users by nickname'),
        ),
        body: FutureBuilder<dynamic>(
          future: _getUsersByNickname(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: _nicknames.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: TextStyle(),
                    ),
                    title: Text(_nicknames[index]),
                    trailing: FlatButton(
                      child: Text("See their Posts"),
                      onPressed: () =>
                          _goToUserPostByNicknameScreen(_nicknames[index]),
                    ),
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