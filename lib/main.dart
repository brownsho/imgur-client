import 'package:epicture/screens/home/home.dart';
import 'package:epicture/screens/auth/auth.dart';
import 'package:epicture/screens/loading/loading.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Epicture',
        initialRoute: '/auth',
        routes: {
          '/auth': (context) => Auth(),
          '/loading': (context) => Loading(),
          '/home': (context) => Home(),
        },
      ),
    );
