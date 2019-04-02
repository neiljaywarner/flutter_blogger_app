import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blogger_app/Post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';


Future<PostResponse> fetchPost() async {
  final response = await http.get('http://gordonferguson.org/wp-json/wp/v2/posts');

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
      title: 'Gordon Ferguson',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Gordon Ferguson')),
        body: Center(
          child: FutureBuilder<PostResponse>(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int length = snapshot.data.posts.length;
                debugPrint("has data: length=$length");
                return ListView.builder(
                    itemCount: snapshot.data.posts.length,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (BuildContext _context, int i) {
                      return PostCard(post: snapshot.data.posts[i]);
                    }
                );
              } else if (snapshot.hasError) {
                debugPrint("Has Error ${snapshot.error}");
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

class PostCard extends StatelessWidget {

  final Post post;

  PostCard({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        title: Text(post.title),
        subtitle: Html(data: post.excerpt),
        onTap: () => _launchURL(post.link),
      ),
    );
  }
}


_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
