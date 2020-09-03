import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jsonplaceholder/models/Post.dart';
import 'package:jsonplaceholder/models/User.dart';
import 'package:jsonplaceholder/theme.dart';

class Posts extends StatefulWidget {
  final User user;

  const Posts({Key key, this.user}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Future<List<Post>> fetchUsers() async {
    var response = await http.get(
        'https://jsonplaceholder.typicode.com/posts?userId=' +
            widget.user.id.toString());

    if (response.statusCode == 200) {
      return List<Post>.from(
          json.decode(response.body).map((x) => Post.fromJson(x)));
    } else {
      throw Exception('Failed to load' + widget.user.username + "'s posts");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username + "'s posts"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  for (var item in snapshot.data)
                    Card(
                      elevation: 1,
                      child: ListTile(
                        onTap: () {},
                        title: Text(item.title),
                        subtitle: Text(item.body),
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
