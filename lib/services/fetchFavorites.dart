import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class FetchFavorites {
  String token;
  String username;

  List<dynamic> gallery;
  List images = List();
  List imagesId = List();
  Map imagesInfos = {};

  FetchFavorites({@required this.token, @required this.username});

  Future<void> fetch() async {
    Response response = await get(
        'https://api.imgur.com/3/account/${this.username}/favorites/',
        headers: {
          'Authorization': 'Bearer ${this.token}',
        });

    this.gallery = jsonDecode(response.body)['data'];
    this.gallery.forEach((element) {
      imagesInfos = {};
      if (element['type'] == 'image/png' || element['type'] == 'image/jpeg') {
        imagesInfos['id'] = element['id'];
        imagesInfos['link'] = element['link'];
        imagesInfos['title'] = element['title'];
        imagesInfos['views'] = element['views'];
        imagesInfos['comment_count'] = element['comment_count'];
        imagesInfos['favorite_count'] = element['favorite_count'];
        imagesInfos['ups'] = element['ups'];
        imagesInfos['downs'] = element['downs'];
        this.images.add(imagesInfos);
      }
    });
  }

  Future<void> fetchAllId() async {
    Response response = await get(
        'https://api.imgur.com/3/account/${this.username}/favorites/',
        headers: {
          'Authorization': 'Bearer ${this.token}',
        });

    this.gallery = jsonDecode(response.body)['data'];

    this.gallery.forEach((element) {
      if (element['type'] == 'image/png' || element['type'] == 'image/jpeg') {
        this.imagesId.add(element['id']);
      }
    });
  }
}
