import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_magna_web/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  String pref = 'data', user = 'data';
  runApp(
      MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged,
          ),
          StreamProvider<ConnectivityResult>.value(
            value: Connectivity().onConnectivityChanged,

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
      home: HomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('schools').snapshots(),
        builder: (context,snap)=>(snap.hasData)?Center(
          child :ListView.builder(
              itemCount: 3,
              itemBuilder: (context,i)=>ListTile(
                leading: Icon(Icons.school),
            title: Text(snap.data.documents[i]['name']),
            subtitle: Text(snap.data.documents[i]['address']),
            onTap: (){},

          ))
        ):Center(child: CircularProgressIndicator()),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
