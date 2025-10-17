import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModelManga extends ChangeNotifier {
  final String id;
  final String title;
  final String imgUrl;
  final String latestChapter;
  final String description;

  ModelManga({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.latestChapter,
    required this.description,
  });

  factory ModelManga.fromJson(Map<String, dynamic> json, bool hasGenre) {
    String image = "";
    if (hasGenre) {
      image = json["image"];
    } else {
      image = json["imgUrl"];
    }
    return ModelManga(
      id: json['id'],
      title: json['title'],
      imgUrl: image,
      latestChapter: json['latestChapter'],
      description: json['description'],
    );
  }

  factory ModelManga.fromSearchedJson(Map<String, dynamic> json) {
    return ModelManga(
      id: json['id'],
      title: json['title'],
      imgUrl: json['imgUrl'],
      latestChapter: "",
      description: "",
    );
  }

  Uint8List? _image;
  Uint8List? get image => _image;

  setImage() async {
    try {
      var response = await http.get(Uri.parse(imgUrl));
      var responseBody = response.bodyBytes;
      _image = responseBody;
      notifyListeners();
    } catch (_) {
      setImage();
    }
  }
}
