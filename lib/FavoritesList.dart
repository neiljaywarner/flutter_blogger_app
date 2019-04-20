
import 'package:flutter_blogger_app/Post.dart';

class FavoritesList {
  final List<String> favoriteSlugs;

  FavoritesList(this.favoriteSlugs);

  bool hasPost(Post favorite) => favoriteSlugs.any((currentSlug) => (currentSlug == favorite.slug));

  //factory PostResponse.fromJson(List<dynamic> parsedJson) => new PostResponse(parsedJson.map((i)=>Post.fromJson(i)).toList());

}