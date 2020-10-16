import 'dart:io' as Io;
import 'dart:convert';

import 'package:InstaPost/providers/add_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  static const routeName = '/addpost';

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _postData = {'text': '', 'hashtags': ''};
  Io.File _image;
  final picker = ImagePicker();
  String encodedimage;

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = Io.File(pickedFile.path);
    });
    if (_image != null) {
      final bytes = Io.File(pickedFile.path).readAsBytesSync();
      encodedimage = base64Encode(bytes);
      print(encodedimage);
    }
  }

  void _statusDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Status'),
              content: Text('Post Submitted Succefully'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add your Post',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(144),
                ],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please give some Post Description';
                  }
                },
                onSaved: (value) {
                  _postData['text'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '#HashTags',
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please give atleast one Hashtag to your Post';
                  }
                },
                onSaved: (value) {
                  _postData['hashtags'] = value;
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pick an Image',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: GestureDetector(
                  onTap: _getImage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: double.infinity,
                          // height: 400.0,
                          color: Colors.black12,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 50.0),
                          child: Center(
                              child: _image == null
                                  ? FaIcon(FontAwesomeIcons.plus)
                                  : Image.file(_image)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          await Provider.of<AddPostProvider>(context,
                                  listen: false)
                              .addPost(_postData['text'], _postData['hashtags'],
                                  encodedimage);
                          _statusDialog();
                        }
                      },
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
