import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manga_reader/models/model_manga.dart';
import 'package:http/http.dart' as http;
import 'package:manga_reader/models/model_manga_info.dart';
import 'package:manga_reader/models/model_manga_reader.dart';

class ServiceManga extends ChangeNotifier {
  List<ModelManga> _mangaList = [];
  List<ModelManga> get mangaList => _mangaList;

  ModelMangaInfo? _selectedManga;
  ModelMangaInfo? get selectedManga => _selectedManga;

  ModelMangaReader? _mangaReader;
  ModelMangaReader? get mangaReader => _mangaReader;

  getMangaList(int pageNumber) async {
    if (_mangaList.length > 1) {
      _mangaList.clear();
      notifyListeners();
    }
    var response = await http.get(
      Uri.parse("https://gomanga-api.vercel.app/api/manga-list/$pageNumber"),
    );
    var jsonResponse = jsonDecode(response.body);
    Iterable data = jsonResponse["data"];
    _mangaList = List<ModelManga>.from(
      data.map((manga) => ModelManga.fromJson(manga)),
    );
    notifyListeners();

    for (ModelManga manga in _mangaList) {
      manga.setImage();
    }
  }

  searchManga(String title) async {
    if (_mangaList.length > 1) {
      _mangaList.clear();
      notifyListeners();
    }

    var response = await http.get(
      Uri.parse("http://gomanga-api.vercel.app/api/search/$title"),
    );
    var jsonResponse = jsonDecode(response.body);
    Iterable searchedManga = jsonResponse['manga'];
    _mangaList = List<ModelManga>.from(
      searchedManga.map((manga) => ModelManga.fromSearchedJson(manga)),
    );
    notifyListeners();

    for (ModelManga manga in _mangaList) {
      manga.setImage();
    }
  }

  getSelectedManga(String id) async {
    _selectedManga = null;
    var response = await http.get(
      Uri.parse("https://gomanga-api.vercel.app/api/manga/$id"),
    );
    var responseJson = jsonDecode(response.body);
    _selectedManga = ModelMangaInfo.fromJson(responseJson);
    _selectedManga!.chapters.sort((a,b)=>double.parse((a.chapterId).toString().replaceAll("-", ".")).compareTo(double.parse((b.chapterId).toString().replaceAll("-", "."))));
    notifyListeners();
    _selectedManga!.getMangaImage();
  }

  getMangaPages(String id, String chapterID) async {
    _mangaReader = null;

    String getMangaPagesUrl = "https://gomanga-api.vercel.app/api/manga/$id/$chapterID";

    print(getMangaPagesUrl);

    var response = await http.get(
      Uri.parse(getMangaPagesUrl),
    );
    var responseJson = jsonDecode(response.body);

    _mangaReader = ModelMangaReader.fromJson(responseJson);
    notifyListeners();
 
    _mangaReader!.loadMangaImages();
  }
}
