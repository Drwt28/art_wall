import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intent/intent.dart' as intent;
import 'package:intent/action.dart' as action;
import 'package:Art_wall/utils/contants.dart';
import 'package:wallpaper/wallpaper.dart';


class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

 File _imageFile = null;
 int progress;
 bool wallpaper = false;
 double prog=0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> details = ModalRoute.of(context).settings.arguments;
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        leading: SizedBox(),
        backgroundColor: Colors.white,
        title: Text('Details',style: TextStyle(color: Colors.pink),),
        actionsIconTheme: IconThemeData(color: Colors.pink),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              downloadImage(details['links_html']);

            },
            icon: Icon(Icons.file_download),
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.share),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[



            Hero(
              tag: details['id'],
              child: Center(
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(15)
                  ),
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.height*0.8,

                  child: Image.network(details['urls_regular'],
                    fit: BoxFit.cover,
                    loadingBuilder: (context,child,progress){
                    return progress == null? child:Center(
                      child: LinearProgressIndicator(

                        value: (progress.cumulativeBytesLoaded/progress.expectedTotalBytes)*100,
                      ),
                    ) ;
                    },

                  )



                ),
              ),
            )
          , Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width*.8,
                height: 45,
                child: wallpaper ? Center(child: CircularProgressIndicator()):RaisedButton(

                  color: Colors.pink,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('Set Wallpaper'),),
                  onPressed: (){

                    setWallpaper(details['urls_regular']);
                  },
                ),
              ),
            ),
          )
          ],
        ),
      ),


    ) ;
  }

  Future _isPhotoFavorite(String pid) async {
    List<Map> result = await kDatabase.query(kTable,
        columns: ['pid'], where: 'pid = ?', whereArgs: [pid]);
    return result.isEmpty;
  }

  setWallpaperFromIntent(){
    intent.Intent()
..setAction(action.Action.ACTION_SET_WALLPAPER)
..startActivityForResult().then(
(_) => print(_),);
  }
  setWallpaper(String url)
  {
    setState(() {
      wallpaper = true;
    });
    Stream stream = Wallpaper.ImageDownloadProgress(url);

    stream.listen((val){

    },onDone: (){
      setState(() {
        wallpaper = false;
        showModalBottomSheet(context: context, builder: (context)=>Wrap(
          children: <Widget>[
           ListTile(
             leading: Icon(Icons.add_to_home_screen),
             title: Text('HomeScreen'),
             onTap: (){
               Wallpaper.homeScreen().then((val){
                 Navigator.pop(context);
                 Scaffold.of(context).showSnackBar(SnackBar(content: Text('Wallpaper Set Succesfully'),
                   duration: Duration(seconds: 2),));
               });
             },
           ),ListTile(
             leading: Icon(Icons.screen_lock_portrait),
             title: Text('LockScreen'),
             onTap: (){
               Wallpaper.lockScreen().then((val){
                 Navigator.pop(context);
                 Scaffold.of(context).showSnackBar(SnackBar(content: Text('Wallpaper Set Succesfully'),
                 duration: Duration(seconds: 2),));
               });
             },
           ),ListTile(
             leading: Icon(Icons.select_all),
             title: Text('Both'),
             onTap: (){
               Wallpaper.bothScreen().then((val){
                 Navigator.pop(context);
                 Scaffold.of(context).showSnackBar(SnackBar(content: Text('Wallpaper Set Succesfully'),
                   duration: Duration(seconds: 2),));
               });
             },
           ),ListTile(

             title: Text('Cancel'),
             onTap: (){
               Navigator.pop(context);
             },
           )
          ],
        ));
      });
    });

  }

  downloadImage(String url)
  async {
    showDialog(context: context,useRootNavigator: true,builder: (context)=>AlertDialog(
      title: Center(child: Icon(Icons.file_download,color: Colors.pink,),),
      content: Text('Wallpaper is downloading...Please Wait'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ],


    ));
    var ImageId  = await ImageDownloader.downloadImage(url);
    if(_imageFile == null)
      {

      }
      else{
        Navigator.pop(context);
    }


  }
}
class TopBar extends StatelessWidget  implements PreferredSizeWidget{

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Details',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.w700,
                  fontSize: 35),
            ),
          ),


        ],
      ),
    );
  }

  @override

  Size get preferredSize => Size.fromHeight(MediaQuery.of(context).size.height*0.17);

  TopBar(this.context);
}

//Scaffold(
//appBar: AppBar(
//title: Text('Wallpaper'),
//actions: <Widget>[
//FutureBuilder(
//future: _isPhotoFavorite(details['id']),
//builder: (context, snapshot) {
//if (snapshot.hasData &&
//snapshot.connectionState == ConnectionState.done) {
//if (snapshot.data) {
//return IconButton(
//icon: Icon(Icons.favorite_border),
//onPressed: () async {
//await kDatabase.insert(kTable, {
//'pid': details['id'],
//'urls_raw': details['urls_raw'],
//'urls_regular': details['urls_regular'],
//'links_html': details['links_html'],
//'name': details['user']['name'],
//'location': details['user']['location'],
//'likes': details['likes'],
//'height': details['height'],
//'width': details['width'],
//'created_at': details['created_at'],
//}).then((_) {
//setState(() {});
//Scaffold.of(context).showSnackBar(SnackBar(
//content: Text('Added to favorites'),
//action: SnackBarAction(
//label: 'View',
//onPressed: () {
//Navigator.pushNamed(context, '/favorites');
//},
//),
//));
//});
//},
//);
//} else {
//return IconButton(
//icon: Icon(Icons.favorite),
//onPressed: () async {
//await kDatabase.delete(kTable,
//where: 'pid = ?',
//whereArgs: [details['id']]).then((_) {
//setState(() {});
//Scaffold.of(context).showSnackBar(SnackBar(
//content: Text('Removed from favorites'),
//));
//});
//},
//);
//}
//}
//return SizedBox();
//},
//),
//IconButton(
//icon: Icon(Icons.file_download),
//onPressed: () async {
//if (await canLaunch(details['urls_raw']))
//launch(details['urls_raw']);
//},
//),
//IconButton(
//icon: Icon(Icons.launch),
//onPressed: () async {
//if (await canLaunch(details['links_html']))
//launch(details['links_html']);
//},
//),
//],
//),
//body: SingleChildScrollView(
//child: Center(
//child: Column(
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//crossAxisAlignment: CrossAxisAlignment.center,
//children: <Widget>[
//
//
//Padding(
//padding: const EdgeInsets.all(18.0),
//child: Text(
//'Details',
//style: TextStyle(
//color: Colors.pink,
//fontWeight: FontWeight.w700,
//fontSize: 35),
//),
//),
//Image.network(details['urls_regular']),
//ListTile(
//onTap: () {},
//title: Text(details['user']['name'] ?? 'N/A'),
//leading: Icon(Icons.person),
//subtitle: Text('Author'),
//),
//ListTile(
//onTap: () {},
//title: Text(details['user']['location'] ?? 'N/A'),
//leading: Icon(Icons.location_on),
//subtitle: Text('Location'),
//),
//ListTile(
//onTap: () {},
//title: Text(details['likes'].toString() ?? 'N/A'),
//leading: Icon(Icons.favorite),
//subtitle: Text('Likes'),
//),
//ListTile(
//onTap: () {},
//title: Text('${details['width']} x ${details['height']}'),
//leading: Icon(Icons.aspect_ratio),
//subtitle: Text('Dimensions'),
//),
//ListTile(
//onTap: () {},
//title: Text('${details['created_at']}'),
//leading: Icon(Icons.calendar_today),
//subtitle: Text('Created'),
//),
//],
//),
//),
//),
//floatingActionButton: FloatingActionButton(
//onPressed: () async {
//intent.Intent()
//..setAction(action.Action.ACTION_SET_WALLPAPER)
//..startActivityForResult().then(
//(_) => print(_),
//onError: (e) => print(e),
//);
//},
//child: Icon(Icons.wallpaper),
//),
//);
