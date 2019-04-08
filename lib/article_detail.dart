import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blogger_app/Post.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter/material.dart';
import 'package:share/share.dart';

//TODO: 1.Spinner, 2) unescape with dart class
// 3. futurebuilder.
class DetailScreen extends StatelessWidget {
  final Post post;

  DetailScreen({Key key, @required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _shareMessage = "Check out this article '${post.title}'\n${post.link}";
    return Scaffold(
      appBar: AppBar(
          title: Text("Black Tax White Benefits"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () => Share.share(_shareMessage),
            ),
          ]),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: post.imageUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network('http://blacktaxandwhitebenefits.com/wp-content/uploads/2016/11/hand-1917895_1920.jpg'),
                    ),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Text(
                          post.title,
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        )),
                    Padding(padding: EdgeInsets.all(16.0), child: Html(data: post.content)),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
// extremely slight few lines borrowwed from flutter_wordcamp, and inspiration
// but almost all code diffferent, dependencies different, second screen new,etc