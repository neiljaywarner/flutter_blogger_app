import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blogger_app/FavoritesList.dart';
import 'package:flutter_blogger_app/Post.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';


class DetailScreen extends StatefulWidget {
  final Post post;

  DetailScreen({Key key, @required this.post}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}


class _DetailScreenState extends State<DetailScreen> {
  final LocalStorage storage = new LocalStorage('btwb151');
  var _shareMessage;
  List<String> favorites = List<String>();

  int length;

  @override
  void initState() {
    _shareMessage = "Check out this article '${widget.post.title}'\n${widget.post.link}";

    super.initState();

  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
      future: storage.ready,
      builder: (context, snapshot) {
        if (storage.getItem("my_favorites") != null)  {
          favorites = storage.getItem("my_favorites");
        }
        length = favorites.length;
        print('num favorites=$length');
        return Scaffold(
          appBar: AppBar(
              title: Text("Black Tax White Benefits $length"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () => Share.share(_shareMessage),
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () => toggleFavorite(widget.post),
                  // TODO: border star if already favorites
                ),
              ]),
          body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: widget.post.imageUrl,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.network('http://blacktaxandwhitebenefits.com/wp-content/uploads/2016/11/hand-1917895_1920.jpg'),
                        ),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: new Text(
                              widget.post.title,
                              style: new TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            )),
                        Padding(padding: EdgeInsets.all(16.0), child: Html(data: widget.post.content)),
                      ],
                    ),
                  )
                ],
              )),
        );
      }
    );

  void toggleFavorite(Post post) async {
    await storage.ready;
    if (favorites.contains(post.slug)) {
      print("remove b/c favorites has post ${post.slug}");
      favorites.remove(post.slug);
    } else {
      print("add b/c favorites does not have post ${post.slug}");
      favorites.add(post.slug);
    }
    if (favorites.length==0) {
      print("favorites empty; clear storage");
      storage.clear();
    } else {
      print("About to set my favorites to $favorites}");
      storage.setItem("my_favorites", favorites);
    }
    setState(() {
      print("rebuilding after toggling favorite");
      // just rebuild, it will update the star.
    });
  }
}
// extremely slight few lines borrowwed from flutter_wordcamp, and inspiration
// but almost all code diffferent, dependencies different, second screen new,etc