import 'package:flutter/material.dart';
import 'package:manga_reader/components/widget_custom_button.dart';
import 'package:manga_reader/components/widget_custom_floating_action_button.dart';
import 'package:manga_reader/components/widget_custom_text_field.dart';
import 'package:manga_reader/components/widget_manga_display.dart';
import 'package:manga_reader/service_manga.dart';

IconData _mainFloatingIcon = Icons.expand_less_rounded;
bool _allFloatingShowing = false;
final TextEditingController _searchController = TextEditingController();
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
            builder: (context, child) => _mangaService.mangaList.isEmpty
                ? Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(color: Colors.black,),
                    ),
                  )
                : SingleChildScrollView(
                    child: Wrap(
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
              WidgetCustomTextField(textController: _searchController),
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
}
