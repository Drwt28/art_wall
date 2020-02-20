import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:Art_wall/screens/SearchWallaper.dart';
import 'package:Art_wall/utils/api_constants.dart';
import 'package:wallpaper/wallpaper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final pages = ['Color', 'Texture', 'Pattern', 'Abstract', 'Nature', 'Trees','Amoled'];

  dynamic _parsedResponse;

  int _currentIndex = 0;
  PageController controller;

  ScrollController listViewController;

  @override
  void initState() {
    controller = PageController();
    listViewController = ScrollController();
    _parsedResponse = '';

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: ListView.builder(
                addRepaintBoundaries: true,
                itemCount: pages.length,
                controller: listViewController,
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i) => !(i == _currentIndex)
                    ? buildTopBarText(pages[i], i)
                    : buildTopBarSelectedText(pages[i], i),
              ),
            ),
            Flexible(
                flex: 9,
                child: PageView(
                  pageSnapping: true,
                  controller: controller,
                  onPageChanged: (val) {
                    setState(() {
                      _currentIndex = val;
                    });
                  },
                  children: <Widget>[
                    WallpaperPages(pages[0]),
                    WallpaperPages(pages[1]),
                    WallpaperPages(pages[2]),
                    WallpaperPages(pages[3]),
                    WallpaperPages(pages[4]),
                    WallpaperPages(pages[5]),

                  ],
                ))
          ],
        ));
  }

  buildListItem(double first, double second) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8),
          height: first,
          width: MediaQuery.of(context).size.width * .38,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage('assets/Art_wall.png'))),
        ),
        Container(
          margin: EdgeInsets.all(8),
          height: second,
          width: MediaQuery.of(context).size.width * .38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage('assets/app.png'))),
        ),
      ],
    );
  }

  buildTopBarText(text, i) {
    return InkWell(
      splashColor: Colors.pink[100],
      onTap: () {
        controller.animateToPage(i,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                text.toString(),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 8,
                height: 2,
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.pink, Colors.pinkAccent],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 100, 10.0));

  buildTopBarSelectedText(text, int i) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              text.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                foreground: Paint()..shader = linearGradient,
              ),
            ),
            SizedBox(
              width: 14,
              height: 2,
              child: Container(
                color: Colors.pink,
              ),
            )
          ],
        ),
      ),
    );
  }

  downloadImage(String photo) async {
    print(photo);

    Stream stream = Wallpaper.ImageDownloadProgress(photo);

    stream.listen((val) {
      print('progress');
    }, onDone: () {
      print('done');
      Wallpaper.bothScreen();
    });
  }

  void setData() async {
    String p = 'Texture';
    for (int page = 0; page < 4; page++) {
      http.Response response = await http.get(
          'https://api.unsplash.com/search/photos/?client_id=$kAccessKey&per_page=30&order_by=popular&query=$p&page=$page');
      _parsedResponse = json.decode(response.body)['results'];

      dynamic data = _parsedResponse.toList();

      for (var photo in data) {
        Firestore.instance.collection('$p').add({
          'id': photo['id'],
          'urls_raw': photo['urls']['raw'],
          'urls_regular': photo['urls']['regular'],
          'user': photo['user'],
          'likes': photo['likes'],
          'color': photo['color'],
          'width': photo['width'],
          'height': photo['height'],
          'download':photo['links']['download'],
          'created_at': photo['created_at'],
          'links_html': photo['links']['html'],
        });
        print('done');
      }
    }
    print('All Set Succesfully');
  }
}

class TopBar extends StatelessWidget implements PreferredSizeWidget {
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
              'Wallpapers',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.w700,
                  fontSize: 35),
            ),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.black12),
            margin: EdgeInsets.only(left: 30, right: 40),
            child: InkWell(
              onTap: () {
                showSearch(
                    context: context, delegate: searchWallpaper());
              },
              splashColor: Colors.pink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Search Papers,People,Moods....',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black26),
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(MediaQuery.of(context).size.height * 0.17);

  TopBar(this.context);
}

class WallpaperPages extends StatefulWidget {
  String query;

  @override
  _WallpaperPagesState createState() => _WallpaperPagesState();

  WallpaperPages(this.query);
}

class _WallpaperPagesState extends State<WallpaperPages> {
  dynamic _parsedResponse;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(widget.query).snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
            body: (!snapshot.hasData)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) {
                      return Material(
                        elevation: 4,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: InkWell(
                          onTap: () {
                            Map<String,dynamic> photo = snapshot.data.documents[i].data;
                            Navigator.pushNamed(context, '/details', arguments: {
                              'id': photo['id'],
                              'urls_raw': photo['urls_raw'],
                              'urls_regular': photo['urls_regular'],
                              'user': photo['user'],
                              'likes': photo['likes'],
                              'color': photo['color'],
                              'width': photo['width'],
                              'height': photo['height'],

                              'created_at': photo['created_at'],
                              'links_html': photo['links_html'],
                            });
                          },
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Hero(
                            tag: snapshot.data.documents[i]['id'],
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  snapshot.data.documents[i]['urls_regular']),
                              placeholder: AssetImage('assets/app.png'),
                            ),
                          ),
                        ),
                      );
                    },
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    staggeredTileBuilder: (i) =>
                        StaggeredTile.count(2, i.isEven ? 2 : 3),
                  ),
          );
        });
    ;
  }

  buildListTile(photo) {
    print(photo.toString());
    return InkWell(
      splashColor: Colors.indigo,
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: {
          'id': photo['id'],
          'urls_raw': photo['urls']['raw'],
          'urls_regular': photo['urls']['regular'],
          'user': photo['user'],
          'likes': photo['likes'],
          'color': photo['color'],
          'width': photo['width'],
          'height': photo['height'],
          'created_at': photo['created_at'],
          'links_html': photo['links']['html'],
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(
          tag: photo['id'],
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(photo['urls']['small']))),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Future _searchWalpapers(String query) async {
    http.Response response = await http.get(
        'https://api.unsplash.com/search/photos/?client_id=$kAccessKey&per_page=30&order_by=popular&query=$query');
    _parsedResponse = json.decode(response.body)['results'];

    return _parsedResponse;
  }
}
