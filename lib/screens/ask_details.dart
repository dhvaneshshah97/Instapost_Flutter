import 'package:InstaPost/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AskDetails extends StatefulWidget {
  static const routeName = '/askdetails';

  @override
  _AskDetailsState createState() => _AskDetailsState();
}

class _AskDetailsState extends State<AskDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _details = {
    'firstname': '',
    'nickname': '',
  };

  void _saveDetails() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('firstname', _details['firstname']);
      prefs.setString('nickname', _details['nickname']);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Homescreen(_details['nickname'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hi there.!'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 200, 15, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Text('Hey, can you give me your details?'),
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Firstname',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please give me your Firstname';
                        }
                      },
                      onSaved: (value) {
                        _details['firstname'] = value;
                      }),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nickname',
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please give me your Nickname';
                        }
                      },
                      onSaved: (value) {
                        _details['nickname'] = value;
                      }),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      onPressed: _saveDetails,
                      child: Text('Submit'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Text('This is just one time setup, so just relax!'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
