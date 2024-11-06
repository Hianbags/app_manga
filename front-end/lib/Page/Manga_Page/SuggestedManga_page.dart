import 'package:appmanga/DatabaseHelper/manga_helper.dart';
import 'package:appmanga/Model/Manga_Model/Manga.dart';
import 'package:appmanga/Page/Manga_Page/manga_detail_page.dart';
import 'package:appmanga/Service/Manga_Service/Manga_Service.dart';
import 'package:appmanga/init/format.dart';
import 'package:flutter/material.dart';

class SuggestedMangaWidget extends StatefulWidget {
  @override
  _SuggestedMangaWidgetState createState() => _SuggestedMangaWidgetState();
}

class _SuggestedMangaWidgetState extends State<SuggestedMangaWidget> {
  late Future<List<Manga>> _suggestedMangas;

  @override
  void initState() {
    super.initState();
    _suggestedMangas = _fetchSuggestedMangas();
  }

  Future<List<Manga>> _fetchSuggestedMangas() async {
    try {
      List<int> topCategoryIds = await DatabaseMangaCategoryHelper.getTopThreeCategoryIds();
      return await MangaCategoryService().getMangasByCategoryIds(topCategoryIds , 1);
    } catch (e) {
      print('Error fetching suggested mangas: $e');
      return [];
    }
  }

  Widget _buildMangaCard(Manga manga) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MangaDetailPage(mangaId: manga.id),
            ),
          );
        },
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: NetworkImage(manga.image),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 150,
                height: 240,  // Reduced height
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        manga.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              offset: Offset(1.5, 1.5),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
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
                                shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 2.0,
                                    color: Colors.black,
                                  ),
                                ],
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
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 2.0,
                                  color: Colors.black,
                                ),
                              ],
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Manga>>(
      future: _suggestedMangas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No suggestions available'));
        } else {
          List<Manga> mangas = snapshot.data!;
          return SizedBox(
            height: 240,  // Reduced height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mangas.length,
              itemBuilder: (context, index) {
                Manga manga = mangas[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildMangaCard(manga),
                );
              },
            ),
          );
        }
      },
    );
  }
}
