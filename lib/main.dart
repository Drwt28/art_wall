import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Art_wall/screens/demo.dart';

import 'package:Art_wall/screens/details.dart';
import 'package:Art_wall/screens/favorites.dart';
import 'package:Art_wall/screens/home.dart';
import 'package:Art_wall/screens/settings.dart';

import 'package:Art_wall/utils/db_provider.dart';
import 'package:Art_wall/utils/contants.dart';
import 'package:Art_wall/screens/demo.dart';

void main() async {
  runApp(App());
  kDatabase = await DatabaseProvider.open();
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Art_wall',
      initialRoute: '/',
      routes: {
        '/': (context)=>HomePage(),
        '/details' : (context)=>DetailsScreen()
      },



    );
  }


}
