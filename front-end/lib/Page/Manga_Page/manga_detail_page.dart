import 'package:appmanga/DatabaseHelper/manga_helper.dart';
import 'package:appmanga/Model/Manga_Model/manga_detail_model.dart' as model;
import 'package:appmanga/Page/Manga_Page/ChapterList_detail_page.dart';
import 'package:appmanga/init/format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/Model/Manga_Model/reading_history_model.dart';
import 'package:appmanga/Page/Manga_Page/customappbar.dart';
import 'package:appmanga/Service/Manga_Service/manga_detail_service.dart';
import 'package:appmanga/provider_model/Manga/reding_history.dart';
import 'package:appmanga/Page/Manga_Page/DescriptionSection_page.dart';

class MangaDetailPage extends StatefulWidget {
  final int mangaId;

  const MangaDetailPage({required this.mangaId, Key? key}) : super(key: key);

  @override
  _MangaDetailPageState createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  late Future<List<dynamic>> _mangaDetailFuture;
  late ScrollController _scrollController;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _mangaDetailFuture = Future.wait([
      MangaDetailService().getMangaDetail(widget.mangaId),
      DatabaseHelper().getReadingHistoryForManga(widget.mangaId),
    ]);
    _scrollController = ScrollController()..addListener(_scrollListener);

    _updateCategoryViews(); // Add this line
  }

  void _updateCategoryViews() async {
    final mangaDetail = await MangaDetailService().getMangaDetail(widget.mangaId);
    await DatabaseMangaCategoryHelper.addViewedCategories(mangaDetail.categories);

  }

  void _scrollListener() {
    setState(() {
      _opacity = (200 - _scrollController.offset) / 200;
      _opacity = _opacity.clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _mangaDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          final mangaDetail = snapshot.data![0] as model.MangaDetail;
          final readingHistory = snapshot.data![1] as ReadingHistory?;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<ReadingHistoryNotifier>(context, listen: false)
                .updateReadingHistory(readingHistory);
          });
          return Scaffold(
            body: Stack(
              children: [
                _CoverImage(mangaDetail: mangaDetail, opacity: _opacity),
                NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) => true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 300),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DescriptionSection(mangaDetail: mangaDetail),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              color: Color.fromARGB(255, 20, 20, 20),
                              child: ChapterList(mangaDetail: mangaDetail,),
                            ),
                          ),
                        ),
                        SizedBox(height: 200), // Add some extra space at the bottom
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 33,
                  right: 33,
                  bottom: 30,
                  child: CustomBottomAppBar(mangaDetail: mangaDetail),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _CoverImage extends StatelessWidget {
  final model.MangaDetail mangaDetail;
  final double opacity;

  const _CoverImage({required this.mangaDetail, required this.opacity, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double coverImageHeight = 400;

    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: opacity,
      child: Container(
        width: double.infinity,
        height: coverImageHeight,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.network(
                mangaDetail.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: coverImageHeight,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes!)
                          : null,
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: coverImageHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
