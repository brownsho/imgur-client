import 'package:flutter/material.dart';

PreferredSize searchAppBar() {
  return (PreferredSize(
    preferredSize: Size.fromHeight(35),
    child: AppBar(
      backgroundColor: Color(0xff2EE3B8),
      shadowColor: Colors.red,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 5),
          Text(
            'Search',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  ));
}
