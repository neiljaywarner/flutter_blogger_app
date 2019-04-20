import 'package:html_unescape/html_unescape.dart';

class PostResponse {
  final List<Post> posts;

  PostResponse(this.posts);

  List<Map<String, dynamic>> toJSONEncodable() => posts.map((post) => post.toJSONEncodable()).toList();

  factory PostResponse.fromJson(List<dynamic> parsedJson) => PostResponse(parsedJson.map((i)=>Post.fromJson(i)).toList());

}

class Post {
  final String slug;
  final String excerpt;
  final String title;
  final String link;
  final String imageUrl;
  final String content;

  Post({this.slug, this.excerpt, this.title, this.link, this.imageUrl, this.content});

  // TODO: Consider when to embed if ever?
  // eg is jetpack_featured_media_url good enough
  // or we could use smaller images for thumbnails...
  factory Post.fromJson(Map<String, dynamic> json) {
    String excerpt = json['excerpt']['rendered'] ?? "";
    String title = json['title']['rendered'];
    String content = json['content']['rendered'];
    String slug = json['slug'];
    title = HtmlUnescape().convert(title);
    excerpt = HtmlUnescape().convert(excerpt);
    content = HtmlUnescape().convert(content);
    return Post(
      slug: slug,
      title: title,
      excerpt: excerpt,
      link: json['link'],
      imageUrl: json['jetpack_featured_media_url'],
      content: content
    );
  }

  //todo; remove
  Map<String, dynamic> toJSONEncodable() {
    //TODO: refactor similar to json generator
    Map<String, dynamic> m = new Map();

    m['title'] = title;
    m['excerpt'] = excerpt;
    m['link'] = link;
    m['imageUrl'] = imageUrl;
    m['content'] = content;

    return m;
  }

  factory Post.fromLocalStorageJson(Map<String, dynamic> localJson) => Post(
      title: localJson['title'],
      excerpt: localJson['excerpt'],
      link: localJson['link'],
      imageUrl: localJson['imageUrl'],
      content: localJson['content']
    );
}
