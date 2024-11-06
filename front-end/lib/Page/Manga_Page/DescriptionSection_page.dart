import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:appmanga/Model/Manga_Model/manga_detail_model.dart';

class DescriptionSection extends StatelessWidget {
  final MangaDetail mangaDetail;

  const DescriptionSection({required this.mangaDetail});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        color: Color.fromARGB(255, 20, 20, 20),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 1),
        child: ExpandableNotifier(
          child: Column(
            children: [
              Expandable(
                collapsed: _buildCollapsedContent(),
                expanded: _buildExpandedContent(),
              ),
              ExpandableButton(
                child: Builder(
                  builder: (context) {
                    var controller = ExpandableController.of(context, required: true)!;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        controller.expanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          Text(
            'Tác giả: ${mangaDetail.author}',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Thể loại: ${mangaDetail.categories.map((category) => category.title).join(', ')}',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            mangaDetail.description,
            style: GoogleFonts.roboto(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          Text(
            'Tác giả: ${mangaDetail.author}',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Thể loại: ${mangaDetail.categories.map((category) => category.title).join(', ')}',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            mangaDetail.description,
            style: GoogleFonts.roboto(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            mangaDetail.title,
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.yellow),
            const SizedBox(width: 4),
            Text(
              mangaDetail.rating,
              style: GoogleFonts.roboto(color: Colors.white),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.visibility, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              '${mangaDetail.views}',
              style: GoogleFonts.roboto(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
