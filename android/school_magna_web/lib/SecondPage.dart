import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    var pref = Provider.of<SharedPreferences>(context);
    return Scaffold(
      body: Center(
        child: Text(pref.getString('name')),
      ),
    );
  }
}
