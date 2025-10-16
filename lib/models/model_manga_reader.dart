import 'package:flutter/material.dart';
import 'package:manga_reader/models/model_manga_image.dart';

class ModelMangaReader extends ChangeNotifier{
  final String title;
  final String chapterNumber;
  final List<String> imageUrls;
  final List<double> chapters;

  ModelMangaReader({
    required this.title,
    required this.chapterNumber,
    required this.imageUrls,
    required this.chapters,
  });

  factory ModelMangaReader.fromJson(Map<String, dynamic> json) {
    Iterable images = json['imageUrls'];
    Iterable chapterNumbers = json['chapters'];
    return ModelMangaReader(
      title: json['title'],
      chapterNumber: json['chapter'],
      imageUrls: List<String>.from(images.map((a)=>a.toString())),
      chapters: List<double>.from(chapterNumbers.map((a)=>double.parse(a.toString()))),
    );
  }

  List<ModelMangaImage> _mangaPages = [];
  List<ModelMangaImage> get mangaPages => _mangaPages;

  loadMangaImages(){
    if(_mangaPages.isNotEmpty){
      _mangaPages.clear();
    }
    for(String imaageUrl in imageUrls){
      _mangaPages.add(ModelMangaImage(number: 0, imageUrl: imaageUrl));
    }
    notifyListeners();
    
    for(ModelMangaImage image in _mangaPages){
      image.loadImage();
    }
  }
}
