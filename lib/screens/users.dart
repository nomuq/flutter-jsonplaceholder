import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jsonplaceholder/models/User.dart';
import 'package:jsonplaceholder/screens/albums.dart';
import 'package:jsonplaceholder/screens/posts.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Future<List<User>> fetchUsers() async {
    var response = await http.get('https://jsonplaceholder.typicode.com/users');

    if (response.statusCode == 200) {
      return List<User>.from(
          json.decode(response.body).map((x) => User.fromJson(x)));
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  for (var item in snapshot.data)
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Albums(
                              user: item,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        child: Text(item.username.substring(0, 1)),
                      ),
                      // trailing: Container(
                      //     child: OutlineButton(
                      //   child: Text('Albums'),
                      //   onPressed: () {},
                      // )),
                      title: Text(item.name),
                      subtitle: Text(item.email),
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
