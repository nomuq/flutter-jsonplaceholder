import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jsonplaceholder/models/Album.dart';
import 'package:jsonplaceholder/models/Photo.dart';
import 'package:jsonplaceholder/models/User.dart';
import 'package:jsonplaceholder/screens/image_viewer.dart';

class Photos extends StatefulWidget {
  final User user;
  final Album album;

  const Photos({Key key, this.user, this.album}) : super(key: key);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  Future<List<Photo>> fetchAlbums() async {
    var response = await http.get(
        'https://jsonplaceholder.typicode.com/photos?albumId=' +
            widget.album.id.toString());

    if (response.statusCode == 200) {
      return List<Photo>.from(
          json.decode(response.body).map((x) => Photo.fromJson(x)));
    } else {
      throw Exception('Failed to load' + widget.user.username + "'s photos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username + "'s photos"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchAlbums(),
          builder: (BuildContext context, AsyncSnapshot<List<Photo>> snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 3,
                children: <Widget>[
                  for (var item in snapshot.data)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageViewer(
                              photo: item,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color: Theme.of(context).accentColor.withAlpha(10),
                        child: Image.network(
                          item.thumbnailUrl,
                        ),
                      ),
                    ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
