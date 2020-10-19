import 'dart:io' as Io;
import 'dart:convert';
import 'package:InstaPost/providers/add_post.dart';
import 'package:InstaPost/screens/users_by_nickname.dart';
import 'package:InstaPost/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/http_exception.dart';

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

  Future<void> _getImage() async {
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

  void _submitPost() async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print(_postData);
        await Provider.of<AddPostProvider>(context, listen: false)
            .addPost(_postData['text'], _postData['hashtags'], encodedimage);
        bool _goBack = true;
        _statusDialog('Post Submitted Succefully', _goBack);
      }
    } on HttpException catch (error) {
      String errorMessage = "Could not submit post! Try again later";
      if (error.toString().contains('Some strings are not valid hashtags')) {
        errorMessage = "Enter valid hashtags, append '#' to each hashtag";
        bool _goBack = false;
        _statusDialog(errorMessage, _goBack);
      } else {
        bool _goBack = true;
        _statusDialog(errorMessage, _goBack);
      }
    } catch (error) {
      bool _goBack = true;
      _statusDialog('Could not submit post! Try again later', _goBack);
    }
  }

  void _statusDialog(String message, bool goBack) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Status'),
              content: Text(message),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      if (goBack)
                        Navigator.pushReplacementNamed(
                            context, UsersByNickname.routeName);
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
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(144),
                ],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please give some Post Description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _postData['text'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: '#HashTags',
                    labelStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    hintText: '#hashtag1 #hashtag2...',
                    hintStyle: TextStyle(fontSize: 14)),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please give atleast one Hashtag to your Post';
                  }
                  return null;
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
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
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
                      shape: StadiumBorder(),
                      onPressed: _submitPost,
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
