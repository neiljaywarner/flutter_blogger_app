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
  final String imageUrl;
  final String content;

  Post({this.excerpt, this.title, this.link, this.imageUrl, this.content});

  // TODO: Consider when to embed if ever?
  // eg is jetpack_featured_media_url good enough
  // or we could use smaller images for thumbnails...
  factory Post.fromJson(Map<String, dynamic> json) {
    String excerpt = json['excerpt']['rendered'] ?? "";
    String title = json['title']['rendered'];
    String content = json['content']['rendered'];
    title = HtmlUnescape().convert(title);
    excerpt = HtmlUnescape().convert(excerpt);
    content = HtmlUnescape().convert(content);
    return Post(
      title: title,
      excerpt: excerpt,
      link: json['link'],
      imageUrl: json['jetpack_featured_media_url'],
      content: content
    );
  }
}
