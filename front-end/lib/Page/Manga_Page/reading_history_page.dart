import 'package:appmanga/Model/Manga_Model/reading_history_model.dart';
import 'package:appmanga/provider_model/Manga/reding_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadingHistoryPage extends StatefulWidget {
  @override
  _ReadingHistoryPageState createState() => _ReadingHistoryPageState();
}

class _ReadingHistoryPageState extends State<ReadingHistoryPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReadingHistoryListNotifier>(context, listen: false).loadReadingHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đọc'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<ReadingHistoryListNotifier>(
        builder: (context, readingHistoryNotifier, child) {
          if (readingHistoryNotifier.readingHistoryList.isEmpty) {
            return Center(child: Text('Không có lịch sử đọc'));
          } else {
            final readingHistoryList = readingHistoryNotifier.readingHistoryList;
            return GridView.builder(
              padding: EdgeInsets.all(5.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: readingHistoryList.length,
              itemBuilder: (context, index) {
                final history = readingHistoryList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.0),
                              ),
                              child: Image.network(
                                history.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    history.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    formatChapterTitle(history.currentChapter.title),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15.0),
                          onTap: () async {
                            await readingHistoryNotifier.deleteReadingHistory(history.id!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  String formatChapterTitle(String title) {
    RegExp regex = RegExp(r'\d+$');
    Match? match = regex.firstMatch(title);
    if (match != null) {
      String lastNumber = match.group(0)!;
      return "Chương " + lastNumber;
    } else {
      return title;
    }
  }
}
