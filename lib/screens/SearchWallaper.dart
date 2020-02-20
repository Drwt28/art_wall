import 'package:Art_wall/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class searchWallpaper extends SearchDelegate<String>{
  dynamic _parsedResponse = '';
  dynamic _wallpapers = [];


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ];;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context){

    return FutureBuilder(

      future: _searchWalpapers(query),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          _wallpapers = snapshot.data.toList().map(
                (photo) =>
                InkWell(
                  splashColor: Colors.indigo,
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/details',
                        arguments: {
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
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                          , image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(photo['urls']['small'])
                      )
                      ),
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
                      ),

                    ),
                  ),
                ),
          );
          return _renderWallpapers();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
  Widget _renderWallpapers() => ListView(
    children: <Widget>[
      ..._wallpapers,
    ],
  );


  @override
  Widget buildSuggestions(BuildContext context) {

    return SizedBox();
  }



  Future _searchWalpapers(String query) async {
    http.Response response = await http.get(
        'https://api.unsplash.com/search/photos/?client_id=$kAccessKey&per_page=30&query=$query');
    print(json.decode(response.body)['results'].toString());
    _parsedResponse = json.decode(response.body)['results'];

    return _parsedResponse;
  }
}