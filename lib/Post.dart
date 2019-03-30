class PostResponse {
  final List<Post> posts;

  PostResponse(this.posts);

  factory PostResponse.fromJson(List<dynamic> parsedJson) => new PostResponse(parsedJson.map((i)=>Post.fromJson(i)).toList());
}

class Post {
  final String slug;
  final String title;

  Post({this.slug, this.title});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      title: json['title']['rendered'],
      slug: json['slug'],
    );
}