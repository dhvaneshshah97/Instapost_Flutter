import 'package:InstaPost/providers/add_comments.dart';
import 'package:InstaPost/providers/add_post.dart';
import 'package:InstaPost/providers/add_ratings.dart';
import 'package:InstaPost/providers/fetch_post.dart';
import 'package:InstaPost/providers/get_all_hashtags.dart';
import 'package:InstaPost/providers/users_by_nickname.dart';
import 'package:InstaPost/screens/add_posts.dart';
import 'package:InstaPost/screens/ask_details.dart';
import './providers/image_provider.dart';
import 'package:InstaPost/screens/home_screen.dart';
import 'package:InstaPost/screens/list_of_hashtags.dart';
import 'package:InstaPost/screens/users_by_nickname.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/auth_screen.dart';
import 'dart:io';
import './providers/auth.dart';
import 'package:provider/provider.dart';

// Below Class is added to remove a certificate error -> "unable to get local issuer certificate"
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, String> userdata = {
    'email': '',
    'nickname': '',
  };

  String email = '';
  String nickname = '';

  // this method will run initially in order to check whether user is logged in
  Future<Map> _isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? 'notAuthenticated';
    String nickname = prefs.getString('nickname') ?? 'nonick';
    setState(() {
      userdata['email'] = email;
      userdata['nickname'] = nickname;
    });
    return userdata;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UsersByNicknameProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FetchPosts(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => GetAllHashtagsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AddComments(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AddRatings(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => APIImageProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AddPostProvider(),
        ),
      ],
      child: MaterialApp(
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          UsersByNickname.routeName: (ctx) => UsersByNickname(),
          ListOfHashtags.routeName: (ctx) => ListOfHashtags(),
          AddPost.routeName: (ctx) => AddPost(),
          AskDetails.routeName: (ctx) => AskDetails(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: _isUserLoggedIn(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['email'] != 'notAuthenticated') {
                return Homescreen(snapshot.data['nickname']);
              } else {
                return AuthScreen();
              }
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(
                  child: Container(
                color: Theme.of(context).primaryColor,
                child: CircularProgressIndicator(),
              ));
            }
          },
        ),
      ),
    );
  }
}
