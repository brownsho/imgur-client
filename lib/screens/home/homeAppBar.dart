import 'package:flutter/material.dart';

PreferredSize homeAppBar(String avatar) {
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
            Icons.home_filled,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 5),
          Text(
            'Home',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(avatar),
            radius: 15,
          ),
        ),
      ],
    ),
  ));
}
