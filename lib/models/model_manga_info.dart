import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:manga_reader/models/model_manga_chapter.dart';
import 'package:http/http.dart' as http;

class ModelMangaInfo extends ChangeNotifier{
  final String id;
  final String title;
  final String imageUrl;
  final String? author;
  final String status;
  final String lastUpdated;
  final String views;
  final List<String> genres;
  final String rating;
  final List<ModelMangaChapter> chapters;

  ModelMangaInfo({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.status,
    required this.lastUpdated,
    required this.views,
    required this.genres,
    required this.rating,
    required this.chapters,
  });

  factory ModelMangaInfo.fromJson(Map<String, dynamic> json) {
    Iterable chapterList = json['chapters'];
    Iterable genreList = json['genres'];
    return ModelMangaInfo(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      author: json['author'],
      status: json['status'],
      lastUpdated: json['lastUpdated'],
      views: json['views'],
      genres: List<String>.from(genreList.map((e)=>e.toString())),
      rating: json['rating'],
      chapters: List<ModelMangaChapter>.from(chapterList.map((chapter)=>ModelMangaChapter.fromJson(chapter))),
    );
  }

  Uint8List? mangaImage;

  getMangaImage()async{
    var response = await http.get(Uri.parse(imageUrl));
    mangaImage = response.bodyBytes;
    notifyListeners();
  }
}
