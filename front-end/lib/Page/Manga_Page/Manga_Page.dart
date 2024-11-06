import 'dart:ui';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/Model/Manga_Model/banner_model.dart';
import 'package:appmanga/Model/Manga_Model/category_model.dart';
import 'package:appmanga/Model/Manga_Model/reading_history_model.dart';
import 'package:appmanga/Page/Manga_Page/SuggestedManga_page.dart';
import 'package:appmanga/Page/Manga_Page/category_page.dart';
import 'package:appmanga/Page/Manga_Page/manga_list_suggested_page.dart';
import 'package:appmanga/Page/Manga_Page/reading_history_page.dart';
import 'package:appmanga/Service/Manga_Service/category_service.dart';
import 'package:appmanga/provider_model/Manga/manga_search.dart';
import 'package:appmanga/provider_model/Manga/reding_history.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appmanga/Model/Manga_Model/Manga.dart';
import 'package:appmanga/Page/Manga_Page/manga_list_update_page.dart';
import 'package:appmanga/Page/Manga_Page/manga_detail_page.dart';
import 'package:appmanga/Service/Manga_Service/Manga_Service.dart';
import 'dart:async';



class MangaListWidget extends StatefulWidget {
  @override
  _MangaListWidgetState createState() => _MangaListWidgetState();
}

class _MangaListWidgetState extends State<MangaListWidget> {
  late Future<List<BannerModel>> _bannerListFuture;
  late Future<List<Manga>> _mangaListFuture;
  late Future<List<CategoryManga>> _categoryListFuture;
  Future<List<ReadingHistory>>? _readingHistoryFuture;
  int _currentPage = 0;
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _mangaListFuture = MangaService().getMangaList();
    _bannerListFuture = BannerService().getBannerList();
    _categoryListFuture = CategoryService().getCategoryList();
    _focusNode.addListener(_handleFocusChange);
    _readingHistoryFuture = DatabaseHelper().getReadingHistoryList();
    _readingHistoryFuture?.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          Provider.of<ReadingHistoryListNotifier>(context, listen: false).loadReadingHistory();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: brightness == Brightness.dark ? Colors.black : Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        children: <Widget>[
          _buildSearchBar(),
          _buildWidgetWithTitleBanner('Truyện hot nhất', _buildBannerList()),
          Consumer<ReadingHistoryListNotifier>(
            builder: (context, readingHistoryNotifier, child) {
              return readingHistoryNotifier.readingHistoryList.isNotEmpty
                  ? _buildWidgetWithTitleReadingHistory('Lịch sử đọc', _buildReadingHistory())
                  : const SizedBox.shrink();
            },
          ),
          _buildWidgetWithTitleSuggested('Có thể bạn quan tâm ',SuggestedMangaWidget()),
          _buildWidgetWithTitle('Truyện mới cập nhật', _buildMangaList()),
        ],
      ),
    );
  }

  Widget _buildWidgetWithTitleBanner(String title, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTitleRow(title, 'Thêm', () {

        }),
        widget,
      ],
    );
  }
  Widget _buildWidgetWithTitle(String title, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTitleRow(title, 'Thêm', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MangaListPage()),
          );
        }),
        widget,
      ],
    );
  }
  Widget _buildWidgetWithTitleSuggested(String title, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTitleRow(title, 'Thêm', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MangaListSuggesPage()),
          );
        }),
        widget,
      ],
    );
  }
  Widget _buildMangaListForCategory(CategoryManga category) {
    return FutureBuilder<List<Manga>>(
      future: CategoryService().getMangaListByCategory(category.id, 1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load manga list'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No manga available in this category'));
        } else {
          final mangaList = snapshot.data!;
          return SizedBox(
            height: 250.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mangaList.length,
              itemBuilder: (context, index) {
                final manga = mangaList[index];
                return Container(
                  width: 150.0,
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: manga.image,
                              height: 180.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  manga.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
  Widget _buildWidgetWithTitleReadingHistory(String title, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTitleRow(title
            , 'Thêm', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReadingHistoryPage()),
          );
        }),
        widget,
      ],
    );
  }
  Widget _buildWidgetWithTitleCategories(String title, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTitleRow(title, '', () {

        }),
        widget,
      ],
    );
  }
  Widget _buildTitleRow(String title, String buttonText, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.white.withOpacity(0.5),
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.grey[500],
              size: 24.0,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMangaList() {
    return FutureBuilder<List<Manga>>(
      future: _mangaListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          List<Manga> mangaList = snapshot.data!.take(6).toList();
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 0.75,
            ),
            itemCount: mangaList.length,
            itemBuilder: (context, index) {
              Manga manga = mangaList[index];
              return _buildMangaCard(manga);
            },
          );
        }
      },
    );
  }
  Widget _buildReadingHistory() {
    return Consumer<ReadingHistoryListNotifier>(
      builder: (context, readingHistoryNotifier, child) {
        if (readingHistoryNotifier.readingHistoryList.isEmpty) {
          return const Center(child: Text('No reading history available'));
        } else {
          List<ReadingHistory> readingHistoryList = readingHistoryNotifier.readingHistoryList;
          return SizedBox(
            height: 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: readingHistoryList.length,
              itemBuilder: (context, index) {
                ReadingHistory readingHistory = readingHistoryList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MangaDetailPage(mangaId: readingHistory.mangaId),
                      ),
                    );
                  },
                  child: Container(
                    width: 100.0,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            readingHistory.image,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              color: Colors.black.withOpacity(0.4),
                              child: Text(
                                readingHistory.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
  Widget _buildMangaCard(Manga manga) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaDetailPage(mangaId: manga.id),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: NetworkImage(manga.image),
                  fit: BoxFit.cover,
                ),
              ),
              height: 250,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manga.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            formatChapterTitle(manga.chapter!.title),
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          manga.chapter!.timeDiff,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildBannerList() {
    return FutureBuilder<List<BannerModel>>(
      future: _bannerListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return SizedBox(
            height: 240.0,
            child: Stack(
              children: [
                _buildPageView(snapshot.data!),
                _buildPageIndicator(snapshot.data!.length),
              ],
            ),
          );
        }
      },
    );
  }
  Widget _buildCategoryDefaultTabBar() {
    return FutureBuilder<List<CategoryManga>>(
      future: _categoryListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load categories'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No categories available'));
        } else {
          final categories = snapshot.data!;
          return DefaultTabController(
            length: categories.length,
            child: Column(
              children: <Widget>[
                TabBar(
                  isScrollable: true,
                  tabs: categories.map((category) => Tab(text: category.title)).toList(),
                ),
                SizedBox(
                  height: 250.0,
                  child: TabBarView(
                    children: categories.map((category) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MangaListByCategoryPage(
                                      category: category,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Thêm...'),
                            ),
                          ),
                          Expanded(child: _buildMangaListForCategory(category)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
  Widget _buildPageView(List<BannerModel> data) {
    return PageView.builder(
      itemCount: data.length > 5 ? 5 : data.length,
      itemBuilder: (context, index) {
        BannerModel banner = data[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaDetailPage(mangaId: banner.id),
                ),
              );
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    banner.image,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildBannerTextContent(banner),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildBannerImage(banner.image),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
      },
      pageSnapping: true,
      physics: const BouncingScrollPhysics(),
    );
  }
  Widget _buildBannerTextContent(BannerModel banner) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            banner.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            banner.description,
            style: const TextStyle(color: Colors.white),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5.0),
          const Spacer(),
          Row(
            children: [
              const Icon(
                Icons.remove_red_eye,
                color: Colors.white,
                size: 16.0,
              ),
              const SizedBox(width: 5.0),
              Text(
                '${banner.views}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Text(
            'Đánh giá: ${banner.rating}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
  Widget _buildBannerImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
  Widget _buildPageIndicator(int length) {
    return Positioned(
      bottom: 20.0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          length > 5 ? 5 : length,
              (index) => Container(
            width: _currentPage == index ? 12.0 : 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: _currentPage == index ? Colors.blueAccent : Colors.grey.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          focusNode: _focusNode,
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm manga...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: _onSearchChanged,
        ),
      ),
    );
  }
  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: Material(
            elevation: 4.0,
            child: Consumer<MangaProvider>(
              builder: (context, mangaProvider, child) {
                if (mangaProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: mangaProvider.mangas.length,
                    itemBuilder: (context, index) {
                      final searchManga = mangaProvider.mangas[index];
                      return ListTile(
                        leading: Image.network(
                            searchManga.image, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(searchManga.title),
                        subtitle: searchManga.chapterTitle != null ? Text(formatChapterTitle(searchManga.chapterTitle!)) : null,
                        onTap: () {
                          _hideOverlay();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MangaDetailPage(mangaId: searchManga.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        context.read<MangaProvider>().searchManga(query);
        if (_focusNode.hasFocus) {
          _showOverlay(context);
        }
      } else {
        context.read<MangaProvider>().mangas.clear();
        _hideOverlay();
      }
    });
  }
  @override
  void dispose() {
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  void _handleFocusChange() {
    if (_focusNode.hasFocus && _searchController.text.isNotEmpty) {
      _showOverlay(context);
    } else {
      _hideOverlay();
    }
  }
  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context)?.insert(_overlayEntry!);
  }
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
String formatChapterTitle(String title) {
  RegExp regex = RegExp(r'\d+$');
  Match? match = regex.firstMatch(title);
  if (match != null) {
    String lastNumber = match.group(0)!;
    return "Ch. $lastNumber";
  } else {
    return title;
  }
}
