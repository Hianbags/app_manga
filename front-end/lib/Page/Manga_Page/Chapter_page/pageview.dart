import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';
import 'package:appmanga/Model/Manga_Model/page_model.dart';

class PageListView extends StatelessWidget {
  final List<PageModel> pages;

  PageListView({required this.pages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Image.network(pages[index].image),
        );
      },
    );
  }
}

class PageBookView extends StatelessWidget {
  final List<PageModel> pages;
  final GlobalKey<PageFlipWidgetState> controller;

  PageBookView({required this.pages, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PageFlipWidget(
      key: controller,
      lastPage: Container(
        color: Colors.grey[300],
        child: Center(
          child: Text(
            'Vuốt để chuyển trang',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
      ),
      children: pages.map((page) => Container(
        color: Colors.black,
        child: Image.network(page.image),
      )).toList(),
    );
  }
}
