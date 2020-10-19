import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text(
            'InstaPost',
            style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
