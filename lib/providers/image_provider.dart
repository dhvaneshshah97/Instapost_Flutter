import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIImageProvider with ChangeNotifier {
  Future<void> getAnImage(int id) async {
    // print(id);
    try {
      final url = "https://bismarck.sdsu.edu/api/instapost-query/image?id=$id";
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final responseData = jsonDecode(response.body);
      // responseData['image'] =
      //     (responseData['image'].toString().replaceAll('\r\n', ''));
      final Uint8List decodeBytes = base64Decode(responseData['image']);
      return decodeBytes;
    } catch (error) {
      throw error;
    }
  }
}
