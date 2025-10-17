import 'package:flutter/material.dart';
import 'package:manga_reader/models/model_manga_image.dart';

class WidgetMangaPage extends StatelessWidget {
  final ModelMangaImage mangaPage;
  const WidgetMangaPage({super.key, required this.mangaPage});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: mangaPage,
      builder: (_, _) => mangaPage.image == null
          ? SizedBox(
              height: 600,
              width: 300,
              child: Center(child: CircularProgressIndicator(color: Colors.black)),
            )
          : InteractiveViewer(
            maxScale: 5,
            child: Image.memory(mangaPage.image!)),
    );
  }
}
