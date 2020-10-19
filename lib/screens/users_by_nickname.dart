import 'package:InstaPost/screens/userpost_by_nickname.dart';
import 'package:InstaPost/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users_by_nickname.dart';
import 'package:async/async.dart';

class UsersByNickname extends StatefulWidget {
  static const routeName = '/usersbynickname';

  @override
  _UsersByNicknameState createState() => _UsersByNicknameState();
}

class _UsersByNicknameState extends State<UsersByNickname> {
  List _nicknames = [];
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    _getUsersByNickname();
  }

  // This method will fetch all nicknames from provider and store in _nicknames list
  Future<void> _getUsersByNickname() async {
    return this._memoizer.runOnce(() async {
      List nicknames =
          await Provider.of<UsersByNicknameProvider>(context, listen: false)
              .getAllUsers();
      setState(() {
        _nicknames = nicknames;
      });
      return nicknames;
    });
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
          title: Text('Users by nickname'),
        ),
        body: FutureBuilder<dynamic>(
          future: _getUsersByNickname(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: _nicknames.length,
                itemBuilder: (context, index) => Card(
                  elevation: 6,
                  child: ListTile(
                    onTap: () =>
                        _goToUserPostByNicknameScreen(_nicknames[index]),
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                      ),
                    ),
                    title: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          _nicknames[index],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Could not fetch nicknames! Try again later',
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
