import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jsonplaceholder/models/Album.dart';
import 'package:jsonplaceholder/models/User.dart';
import 'package:jsonplaceholder/screens/photos.dart';

class Albums extends StatefulWidget {
  final User user;

  const Albums({Key key, this.user}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  Future<List<Album>> fetchAlbums() async {
    var response = await http.get(
        'https://jsonplaceholder.typicode.com/albums?userId=' +
            widget.user.id.toString());

    if (response.statusCode == 200) {
      return List<Album>.from(
          json.decode(response.body).map((x) => Album.fromJson(x)));
    } else {
      throw Exception('Failed to load' + widget.user.username + "'s albums");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username + "'s albums"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchAlbums(),
          builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  for (var item in snapshot.data)
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Photos(
                              user: widget.user,
                              album: item,
                            ),
                          ),
                        );
                      },
                      title: Text(item.title),
                      subtitle: Text('@' + widget.user.username),
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
