import 'package:epicture/screens/favorites/favoritesAppBar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:epicture/screens/favorites/favoritesBody.dart';
import 'package:epicture/screens/home/homeAppBar.dart';
import 'package:epicture/screens/home/homeBody.dart';
import 'package:epicture/screens/search/searchAppBar.dart';
import 'package:epicture/screens/search/searchBody.dart';
import 'package:epicture/screens/user/userAppBar.dart';
import 'package:epicture/screens/user/userBody.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //
  Map data = {};
  int pageIndex = 0;

  List<dynamic> appBar = List(4);

  List<dynamic> body = List(4);

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await Future.delayed(Duration.zero, () {
      setState(() {
        data = ModalRoute.of(context).settings.arguments;

        appBar = [
          homeAppBar(data['avatar']),
          searchAppBar(),
          favoritesAppBar(),
          userAppBar(),
        ];

        body = [
          HomeBody(authData: data['authData']),
          SearchBody(authData: data['authData']),
          FavoritesBody(authData: data['authData']),
          UserBody(accessToken: data['authData']['accessToken']),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: appBar[pageIndex],
      body: body[pageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.01))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 500),
                tabBackgroundColor: Color(0xff2EE3B8).withOpacity(0.9),
                tabs: [
                  GButton(
                    icon: Icons.home,
                    iconColor: Colors.grey[850],
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.search,
                    iconColor: Colors.grey[850],
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.favorite,
                    iconColor: Colors.grey[850],
                    text: 'Favorites',
                  ),
                  GButton(
                    icon: Icons.person,
                    iconColor: Colors.grey[850],
                    text: 'Profile',
                  ),
                ],
                selectedIndex: pageIndex,
                onTabChange: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
