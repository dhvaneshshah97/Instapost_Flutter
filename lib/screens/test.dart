import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  bool showPong = false;
  String finalmsg = '';

  void getPing() async {
    var response = await http.get('https://bismarck.sdsu.edu/api/ping');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var message = jsonResponse['message'];
      this.finalmsg = message;
      print(message);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    setState(() {
      showPong = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Container(
        child: Column(
          children: [
            RaisedButton(
              onPressed: getPing,
              child: Text('ping'),
            ),
            SizedBox(
              height: 50.0,
            ),
            showPong ? Text(this.finalmsg) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
