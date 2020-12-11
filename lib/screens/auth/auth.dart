import 'package:epicture/services/reqUrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  //
  RequestUrl url;
  BuildContext context;
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  void clearData() {
    flutterWebviewPlugin.cleanCookies();
    // flutterWebviewPlugin.clearCache();
    flutterWebviewPlugin.close();
  }

  @override
  void initState() {
    //
    super.initState();
    url = RequestUrl();

    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      Uri uri = Uri.dataFromString(state.url.replaceFirst('#', '&'));

      if (uri.query.contains("access_token")) {
        flutterWebviewPlugin.close();
        Navigator.pushReplacementNamed(
          context,
          '/loading',
          arguments: {
            'accessToken': uri.queryParameters['access_token'],
            'refreshToken': uri.queryParameters['refresh_token'],
            'accountUsername': uri.queryParameters['account_username'],
            'accountID': uri.queryParameters['account_id'],
            'clientID': url.clientID,
          },
        );
      }
    });
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() => this.context = context);
    return WebviewScaffold(
      url: url.requestUrl,
      clearCache: true,
      appCacheEnabled: true,
    );
  }
}
