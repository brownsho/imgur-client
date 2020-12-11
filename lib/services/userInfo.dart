// import
import 'dart:convert';
import 'package:http/http.dart';

class UserInfo {
  String accessToken;
  String username;
  String email;
  List avatarTab;
  String avatarLink;
  String avatarName;

  UserInfo({this.accessToken});

  Future<void> getUser() async {
    Response response = await get('https://api.imgur.com/3/account/me/settings',
        headers: {'Authorization': 'Bearer ${this.accessToken}'});
    Map data = jsonDecode(response.body);
    email = data["data"]["email"];
    username = data["data"]["account_url"];
    avatarName = data['data']['avatar'];

    Response avatarTab = await get(
        'https://api.imgur.com/3/account/{{username}}/available_avatars',
        headers: {
          'Authorization': 'Bearer ${this.accessToken}',
        });

    this.avatarTab = jsonDecode(avatarTab.body)["data"]["available_avatars"];
    this.avatarTab.forEach((element) {
      if (element["name"] == avatarName) {
        avatarLink = element["location"];
      }
    });
  }
}
