import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class ReqHomeData {
  String accessToken;
  String clientID;
  List<dynamic> galleryMap;
  List avatarList = List();
  String avatarName;
  String avatar;

  ReqHomeData({@required this.accessToken, @required this.clientID});

  Future<void> makeRequests() async {
    Response response = await get('https://api.imgur.com/3/account/me/settings',
        headers: {'Authorization': 'Bearer ${this.accessToken}'});
    Map data = jsonDecode(response.body);
    avatarName = data['data']['avatar'];

    Response avatarTab = await get(
        'https://api.imgur.com/3/account/{{username}}/available_avatars',
        headers: {
          'Authorization': 'Bearer ${this.accessToken}',
        });

    this.avatarList = jsonDecode(avatarTab.body)["data"]["available_avatars"];
    this.avatarList.forEach((element) {
      if (element["name"] == avatarName) {
        avatar = element["location"];
      }
    });
  }
}
