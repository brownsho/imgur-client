import 'package:epicture/services/reqHomeData.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  //
  Map data = {};
  ReqHomeData homeData;
  BuildContext context;

  @override
  void initState() {
    //
    super.initState();
    getData();
  }

  void getData() async {
    //
    await Future.delayed(Duration.zero, () {
      setState(() {
        data = ModalRoute.of(context).settings.arguments;
      });
      homeData = ReqHomeData(
          accessToken: data['accessToken'], clientID: data['clientID']);
    });

    await homeData.makeRequests();
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'authData': data,
        'avatar': homeData.avatar,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    setState(() => this.context = context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/loading_screen.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(60, 200, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'EPICTURE',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Discover the',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Montserrat',
                    color: Colors.grey[300],
                  ),
                ),
                Text(
                  'magic of internet',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Montserrat',
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 75),
                Text(
                  'Hey, ${data["accountUsername"]}',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Montserrat',
                    color: Colors.tealAccent,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
