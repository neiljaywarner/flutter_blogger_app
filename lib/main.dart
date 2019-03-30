import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blogger_app/Post.dart';
import 'package:http/http.dart' as http;

Future<PostResponse> fetchPost() async {
  final response = await http.get('http://blacktaxandwhitebenefits.com/wp-json/wp/v2/posts?_embed');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return PostResponse.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    //todo: fimber and crashlytics
    throw Exception('Failed to load posts');
  }
}

void main() => runApp(MyApp(posts: fetchPost()));

class MyApp extends StatelessWidget {
  final Future<PostResponse> posts;

  MyApp({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Black Tax White Benefits',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Black Tax White Benefits')),
        body: Center(
          child: FutureBuilder<PostResponse>(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.posts.first.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
}