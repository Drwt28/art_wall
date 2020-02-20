import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SecondPage.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  QuerySnapshot querySnapshot;

  @override
  void initState() {
    getReffrence();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.4,
          height: MediaQuery.of(context).size.height*0.5,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Image.asset('assets/logo/logo.png',height: 60,width: 60,),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Login ID"
                    ),
                  )
                  ,TextFormField(
                    decoration: InputDecoration(
                        labelText: "Password"
                    ),
                  )

                  ,CupertinoButton(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(10),
                    onPressed: (){
                      login();
                    },
                    child: Text('Log in'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   login() {
    SharedPreferences pref = Provider.of<SharedPreferences>(context);
    pref.setString('name', "Deepanshu").then((value) => Navigator.push(context, MaterialPageRoute(
      builder: (context)=>SecondPage()
    )));
  }

   getReffrence() async{


   }
}
