import 'package:flutter/material.dart';
import 'package:manga_reader/components/widget_custom_button.dart';
import 'package:manga_reader/models/model_manga.dart';
import 'package:manga_reader/page_chapter_list.dart';
import 'package:manga_reader/service_manga.dart';

class WidgetMangaDisplay extends StatelessWidget {
  final ModelManga manga;
  final Size screenSize;
  final ServiceManga mangaService;
  const WidgetMangaDisplay({
    super.key,
    required this.manga,
    required this.mangaService,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    double displayWidth = ((screenSize.width - 20) / 2) - 15;
    return GestureDetector(
      onTap: () => showMangaDialog(context),
      child: Card(
        child: Container(
          width: displayWidth,
          height: displayWidth * 1.3,
          padding: EdgeInsets.all(5),
          child: ListenableBuilder(
            listenable: manga,
            builder: (_, _) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: manga.image == null
                      ? Center(child: CircularProgressIndicator(color: Colors.black,))
                      : Image.memory(
                          manga.image!,
                          width: displayWidth - 10,
                          height: displayWidth * 1,
                          fit: BoxFit.fill,
                        ),
                ),
                SizedBox(height: 5),
                Text(manga.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showMangaDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.all(5),
            width: screenSize.width * 0.8,
            height: screenSize.height * 0.5,

            child: Column(
              children: [
                Text(
                  manga.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: SingleChildScrollView(child: Text(manga.description)),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    WidgetCustomButton(
                      isCloseButton: false,
                      buttonText: "Read",
                      buttonFunction: () async {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageChapterList(
                              mangaService: mangaService,
                              manga: manga,
                            ),
                          ),
                        );
                      },
                    ),
                    WidgetCustomButton(
                      isCloseButton: true,
                      buttonText: null,
                      buttonFunction: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
