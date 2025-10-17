import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModelMangaImage extends ChangeNotifier {
  final String imageUrl;
  final int number;

  ModelMangaImage({required this.number, required this.imageUrl});

  Uint8List? _image;
  Uint8List? get image => _image;

  loadImage() async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      _image = response.bodyBytes;
      notifyListeners();
    } catch (_) {
      loadImage();
    }
  }
}
