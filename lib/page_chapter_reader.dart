import 'package:flutter/material.dart';
import 'package:manga_reader/components/widget_manga_page.dart';
import 'package:manga_reader/service_manga.dart';

late Size _screenSize;

class PageChapterReader extends StatefulWidget {
  final ServiceManga mangaService;
  final String mangaChapterID;
  const PageChapterReader({
    super.key,
    required this.mangaService,
    required this.mangaChapterID,
  });

  @override
  State<PageChapterReader> createState() => _PageChapterReaderState();
}

class _PageChapterReaderState extends State<PageChapterReader> {
  @override
  void initState() {
    super.initState();
    widget.mangaService.getMangaPages(
      widget.mangaService.selectedManga!.id,
      widget.mangaChapterID,
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: widget.mangaService,
            builder: (context, child) => SizedBox(
              height: _screenSize.height,
              width: _screenSize.width,
              child: widget.mangaService.mangaReader == null
                  ? Center(child: CircularProgressIndicator(color: Colors.black,))
                  : ListenableBuilder(
                      listenable: widget.mangaService.mangaReader!,
                      builder: (context, child) => SingleChildScrollView(
                        child: Column(
                          children: widget.mangaService.mangaReader!.mangaPages
                              .map((image) => WidgetMangaPage(mangaPage: image))
                              .toList(),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
