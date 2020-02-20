import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  String pref = 'data', user = 'data';
  runApp(

      MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged,
          ),

          StreamProvider<SharedPreferences>.value(
              value: SharedPreferences.getInstance().asStream()),
          StreamProvider<DocumentSnapshot>.value(
              value: Firestore.instance
                  .collection('schools')
                  .document(pref)
                  .collection('classes')
                  .document(user)
                  .snapshots())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(

              textTheme: GoogleFonts.latoTextTheme(),
              backgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                  color: Colors.white,
                  elevation: 0,
                  textTheme: GoogleFonts.latoTextTheme(),
                  iconTheme: IconThemeData(color: Colors.black),
                  actionsIconTheme: IconThemeData(color: Colors.black)),
              buttonTheme: ButtonThemeData(
                  buttonColor: Colors.blue, splashColor: Colors.indigo)),
          home: MyApp(),
          title: 'School Magna',
        ),
      ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home()
    );
  }
}
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Home')),
    );
  }
}


