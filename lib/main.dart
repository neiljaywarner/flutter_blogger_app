import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blogger_app/Post.dart';
import 'package:flutter_blogger_app/article_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';

Future<PostResponse> fetchPost() async {
  final response = await http.get('http://blacktaxandwhitebenefits.com/wp-json/wp/v2/posts?per_page=100');

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

class MyApp extends StatefulWidget {
  final Future<PostResponse> posts;

  MyApp({Key key, this.posts}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 1;
  List<Widget> _tabContent = <Widget>[];


  @override
  void initState() {
    super.initState();
    _tabContent.add(ArticleFutureBuilder(posts: widget.posts));
    _tabContent.add(Center(child: Text("No favorites at this time.")));
  }
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Black Tax White Benefits',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Black Tax White Benefits')),
        body: Center(
          child: _tabContent[_selectedIndex] ,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.star), title: Text('Favorites')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Theme.of(context).accentColor,
          onTap: _onItemTapped,
        ),
      ),
    );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class ArticleFutureBuilder extends StatelessWidget {
  const ArticleFutureBuilder({
    Key key,
    @required this.posts,
  }) : super(key: key);

  final Future<PostResponse> posts;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostResponse>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int length = snapshot.data.posts.length;
          debugPrint("has data: length=$length");
          return ListView.builder(
              itemCount: snapshot.data.posts.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (BuildContext _context, int i) => PostCard(post: snapshot.data.posts[i])
          );
        } else if (snapshot.hasError) {
          debugPrint("Has Error ${snapshot.error}");
          return Text('Error loading posts.');
        }

        // By default, show a loading spinner
        return CircularProgressIndicator();
      },
    );
  }
}

class PostCard extends StatelessWidget {

  final Post post;

  PostCard({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: post.imageUrl,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Image.network('http://blacktaxandwhitebenefits.com/wp-content/uploads/2016/11/hand-1917895_1920.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8),
            child: ListTile(
              title: Text(post.title),
              subtitle: Html(data: post.excerpt),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(post: post))),
            ),
          ),
        ],
      ),
    );
}