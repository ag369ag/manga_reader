import 'package:flutter/material.dart';
import 'package:manga_reader/models/model_manga.dart';
import 'package:manga_reader/page_chapter_reader.dart';
import 'package:manga_reader/service_manga.dart';

late Size _screenSize;

class PageChapterList extends StatefulWidget {
  final ServiceManga mangaService;
  final ModelManga manga;
  const PageChapterList({
    super.key,
    required this.mangaService,
    required this.manga,
  });

  @override
  State<PageChapterList> createState() => _PageChapterListState();
}

class _PageChapterListState extends State<PageChapterList> {
  @override
  void initState() {
    super.initState();
    widget.mangaService.getSelectedManga(widget.manga.id);
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.mangaService,
          builder: (context, child) => widget.mangaService.selectedManga == null
              ? Container(
                  width: _screenSize.width,
                  height: _screenSize.height,
                  color: Colors.blueGrey.shade200,
                  child: Center(child: CircularProgressIndicator(color: Colors.black)),
                )
              : ListenableBuilder(
                  listenable: widget.mangaService.selectedManga!,
                  builder: (context, child) => Stack(
                    children: [
                      widget.mangaService.selectedManga!.mangaImage == null
                          ? SizedBox(height: 0)
                          : Image.memory(
                              widget.mangaService.selectedManga!.mangaImage!,
                              height: _screenSize.height,
                              width: _screenSize.width,
                              fit: BoxFit.fill,
                              opacity: AlwaysStoppedAnimation(0.4),
                            ),
                      Container(
                        width: _screenSize.width,
                        height: _screenSize.height,
                        padding: EdgeInsets.all(10),
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.mangaService.selectedManga!.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Status: ${widget.mangaService.selectedManga!.status}",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Wrap(
                              runSpacing: 5,
                              spacing: 5,
                              children: widget
                                  .mangaService
                                  .selectedManga!
                                  .genres
                                  .map(
                                    (genre) => Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        genre,
                                        style: TextStyle(color: Colors.white60),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),

                            SizedBox(height: 10),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: widget
                                      .mangaService
                                      .selectedManga!
                                      .chapters
                                      .map(
                                        (chapter) => GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PageChapterReader(
                                                    mangaService:
                                                        widget.mangaService,
                                                    mangaChapterID:
                                                        chapter.chapterId,
                                                  ),
                                            ),
                                          ),
                                          child: Card(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Chapter ${chapter.chapterId}",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
