import 'package:flutter/material.dart';
import 'package:manga_reader/components/widget_custom_button.dart';
import 'package:manga_reader/components/widget_custom_floating_action_button.dart';
import 'package:manga_reader/components/widget_custom_text_field.dart';
import 'package:manga_reader/components/widget_manga_display.dart';
import 'package:manga_reader/service_manga.dart';

IconData _mainFloatingIcon = Icons.expand_less_rounded;
bool _allFloatingShowing = false;
final TextEditingController _searchController = TextEditingController();
final TextEditingController _genreSearchController = TextEditingController();
ServiceManga _mangaService = ServiceManga();
late Size _screenSize;
int _pageNumber = 1;

class PageMangaList extends StatefulWidget {
  const PageMangaList({super.key});

  @override
  State<PageMangaList> createState() => _PageMangaListState();
}

class _PageMangaListState extends State<PageMangaList> {
  @override
  void initState() {
    super.initState();
    _mangaService.getMangaList(_pageNumber);
    //_mangaService.getGenres();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: _screenSize.width,
          height: _screenSize.height,
          padding: EdgeInsets.all(10),
          color: Colors.blueGrey.shade100,
          child: ListenableBuilder(
            listenable: _mangaService,
            builder: (_, _) => _mangaService.mangaList.isEmpty
                ? Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  )
                : SingleChildScrollView(
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 5,
                    spacing: 5,
                    direction: Axis.horizontal,
                    children: _mangaService.mangaList
                        .map(
                          (manga) => WidgetMangaDisplay(
                            manga: manga,
                            mangaService: _mangaService,
                            screenSize: _screenSize,
                          ),
                        )
                        .toList(),
                  ),
                ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: _allFloatingShowing,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // WidgetCustomFloatingActionButton(
                //   buttonFunction: () => filterButtonClicked(context),
                //   buttonIcon: Icons.filter_list_rounded,
                // ),
                SizedBox(height: 5),
                WidgetCustomFloatingActionButton(
                  buttonFunction: () => searchButtonClicked(context),
                  buttonIcon: Icons.search_rounded,
                ),
                SizedBox(height: 5),
                WidgetCustomFloatingActionButton(
                  buttonFunction: () => backPageClicked(),
                  buttonIcon: Icons.navigate_before_rounded,
                ),
                SizedBox(height: 5),
                WidgetCustomFloatingActionButton(
                  buttonFunction: () => nextPageClicked(),
                  buttonIcon: Icons.navigate_next_rounded,
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          WidgetCustomFloatingActionButton(
            buttonFunction: () => mainFloatingButtonClicked(),
            buttonIcon: _mainFloatingIcon,
          ),
        ],
      ),
    );
  }

  mainFloatingButtonClicked() {
    _allFloatingShowing = !_allFloatingShowing;
    if (_allFloatingShowing) {
      _mainFloatingIcon = Icons.expand_more_rounded;
    } else {
      _mainFloatingIcon = Icons.expand_less_rounded;
    }

    setState(() {});
  }

  searchButtonClicked(BuildContext context) {
    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "SEARCH MANGA TITLE",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              WidgetCustomTextField(
                textController: _searchController,
                textChangedEvent: null,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 80,
                    child: WidgetCustomButton(
                      isCloseButton: false,
                      buttonText: "Search",
                      buttonFunction: () {
                        Navigator.pop(context);
                        if (_searchController.text.isEmpty) {
                          _pageNumber = 1;
                          _mangaService.getMangaList(_pageNumber);
                          return;
                        }

                        _mangaService.searchManga(_searchController.text);

                        _searchController.text = "";
                      },
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: WidgetCustomButton(
                      isCloseButton: true,
                      buttonText: null,
                      buttonFunction: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  backPageClicked() {
    if (_pageNumber <= 1) {
      return;
    }
    _pageNumber--;
    _mangaService.getMangaList(_pageNumber);
  }

  nextPageClicked() {
    if (_pageNumber >= 100) {
      return;
    }

    _pageNumber++;
    _mangaService.getMangaList(_pageNumber);
  }

  // filterButtonClicked(BuildContext context) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (_) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadiusGeometry.circular(10),
  //         ),
  //         child: Container(
  //           padding: EdgeInsets.all(5),
  //           width: _screenSize.width * 0.8,
  //           height: _screenSize.height * 0.5,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text(
  //                 "Search genre",
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 5),
  //               WidgetCustomTextField(
  //                 textController: _genreSearchController,
  //                 textChangedEvent: (_) => _mangaService.getSearchedGenre(
  //                   _genreSearchController.text,
  //                 ),
  //               ),
  //               SizedBox(height: 5),
  //               Flexible(
  //                 child: ListenableBuilder(
  //                   listenable: _mangaService,
  //                   builder: (_, _) => SingleChildScrollView(
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.max,
  //                       children: _mangaService.searchedGenre
  //                           .map(
  //                             (genre) => GestureDetector(
  //                               onTap: () {
  //                                 _genreSearchController.text = genre;
  //                                 genreSelected(context);
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: Card(
  //                                       child: Container(
  //                                         padding: EdgeInsets.all(5),
  //                                         child: Text(genre),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           )
  //                           .toList(),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 5),
  //               Row(
  //                 mainAxisSize: MainAxisSize.max,
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   SizedBox(
  //                     width: 80,
  //                     child: WidgetCustomButton(
  //                       isCloseButton: false,
  //                       buttonText: "",
  //                       buttonFunction: () => genreSelected(context),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 80,
  //                     child: WidgetCustomButton(
  //                       isCloseButton: true,
  //                       buttonText: "",
  //                       buttonFunction: () => Navigator.pop(context),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // genreSelected(BuildContext context) {
  //   print(_genreSearchController.text);
  //   Navigator.pop(context);
  //   if (_genreSearchController.text.isEmpty) {
  //     _pageNumber = 1;
  //     _mangaService.getMangaList(_pageNumber);
  //     return;
  //   }

  //   _mangaService.getMangaListByGenre(_genreSearchController.text, _pageNumber);
  //   _genreSearchController.text = "";
  //   _mangaService.resetGenreList();
  // }
}
