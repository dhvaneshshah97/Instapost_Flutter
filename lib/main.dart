import 'package:InstaPost/providers/users_by_nickname.dart';
import 'package:InstaPost/screens/home_screen.dart';
import 'package:InstaPost/screens/users_by_nickname.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/auth_screen.dart';
import 'dart:io';
import './providers/auth.dart';
import 'package:provider/provider.dart';

// Below code is added to remove a certificate error named -> "unable to get local issuer certificate"
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
  String email = '';

  // this method will run initially in order to check whether user is logged in
  _isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? 'notAuthenticated';
    setState(() {
      this.email = email;
    });
  }

  @override
  void initState() {
    super.initState();
    _isUserLoggedIn();
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
      ],
      child: MaterialApp(
        routes: {
          Homescreen.routeName: (ctx) => Homescreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          UsersByNickname.routeName: (ctx) => UsersByNickname(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: email != 'notAuthenticated' ? Homescreen() : AuthScreen(),
      ),
    );
  }
}
