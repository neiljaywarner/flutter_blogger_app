import 'package:html_unescape/html_unescape.dart';

class PostResponse {
  final List<Post> posts;

  PostResponse(this.posts);

  factory PostResponse.fromJson(List<dynamic> parsedJson) => new PostResponse(parsedJson.map((i)=>Post.fromJson(i)).toList());
}

class Post {
  final String excerpt;
  final String title;
  final String link;

  Post({this.excerpt, this.title, this.link});

  factory Post.fromJson(Map<String, dynamic> json) {
    String excerpt = json['excerpt']['rendered'] ?? "";
    String title = json['title']['rendered'];
    title = HtmlUnescape().convert(title);
    excerpt = HtmlUnescape().convert(excerpt);
    return Post(
      title: title,
      excerpt: excerpt,
      link: json['link']
    );
  }
}
