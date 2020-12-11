import 'package:epicture/env.dart';

class RequestUrl {
  //
  String clientID;
  String clientSecret;
  String responseType;
  String state;
  String requestUrl;

  RequestUrl() {
    //
    this.clientID = api['clientID'];
    this.clientSecret = api['clientSecret'];
    this.responseType = api['responseType'];
    this.state = api['state'];

    this.requestUrl = 'https://api.imgur.com/oauth2/authorize?client_id=' +
        this.clientID +
        '&response_type=' +
        this.responseType +
        '&state=' +
        this.state;
  }
}
