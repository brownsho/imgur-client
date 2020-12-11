import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class FetchUploadImages {
  String username;
  String accessToken;
  List<dynamic> gallery;
  List images = List();

  FetchUploadImages({@required this.username, @required this.accessToken});

  Future<void> fetch() async {
    Response resGallery =
        await get('https://api.imgur.com/3/account/me/images', headers: {
      'Authorization': 'Bearer ${this.accessToken}',
    });

    this.gallery = jsonDecode(resGallery.body)['data'];

    this.gallery.forEach((element) {
      this.images.add(element['link']);
    });
  }
}
