
import 'package:flutter_blogger_app/Post.dart';

class FavoritesList {
  final List<Post> favorites;

  FavoritesList(this.favorites);

  List<Map<String,dynamic>> toJSONEncodable() => favorites.map((post) => post.toJSONEncodable()).toList();

  factory FavoritesList.fromLocalStorageJson(List<dynamic> localJson) => FavoritesList(localJson.map((i)=>Post.fromLocalStorageJson(i)).toList());

  //factory PostResponse.fromJson(List<dynamic> parsedJson) => new PostResponse(parsedJson.map((i)=>Post.fromJson(i)).toList());

}