import 'dart:convert';
import 'package:epicture/services/fetchFavorites.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class FetchGallery {
  String clientID;
  String token;
  String username;
  List<dynamic> gallery;
  List images = List();
  Map imagesInfos = {};
  FetchFavorites fetchFavorites;

  FetchGallery(
      {@required this.clientID, @required this.token, @required this.username});

  Future<void> fetch() async {
    Response resGallery =
        await get('https://api.imgur.com/3/gallery/hot/1', headers: {
      'Authorization': 'Client-ID ${this.clientID}',
    });

    this.gallery = jsonDecode(resGallery.body)['data'];

    this.fetchFavorites =
        FetchFavorites(token: this.token, username: this.username);

    await this.fetchFavorites.fetchAllId();

    this.gallery.forEach((element) {
      imagesInfos = {};
      if (element['images'] != null && element['images'][0] != null) {
        if (element['images'][0]['type'] != 'video/jpeg' &&
            element['images'][0]['type'] != 'video/mp4') {
          imagesInfos['id'] = element['images'][0]['id'];
          imagesInfos['link'] = element['images'][0]['link'];
          imagesInfos['title'] = element['title'];
          imagesInfos['views'] = element['views'];
          imagesInfos['comment_count'] = element['comment_count'];
          imagesInfos['favorite_count'] = element['favorite_count'];
          imagesInfos['ups'] = element['ups'];
          imagesInfos['downs'] = element['downs'];
          if (this
              .fetchFavorites
              .imagesId
              .contains(element['images'][0]['id'])) {
            imagesInfos['iconFavoriteColor'] = Colors.red;
            imagesInfos['isLiked'] = true;
          } else {
            imagesInfos['iconFavoriteColor'] = Colors.black;
            imagesInfos['isLiked'] = false;
          }
          this.images.add(imagesInfos);
        }
      }
    });
  }
}
