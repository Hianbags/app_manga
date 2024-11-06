import 'package:flutter/material.dart';

class CustomTabController extends StatefulWidget {
  final Widget child;
  final int length;

  const CustomTabController({
    Key? key,
    required this.child,
    required this.length,
  }) : super(key: key);

  @override
  _CustomTabControllerState createState() => _CustomTabControllerState();
}

class _CustomTabControllerState extends State<CustomTabController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Mô tả'),
              Tab(text: 'Chapters'),
              Tab(text: 'Bình luận'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.child is List<Widget>
                  ? widget.child as List<Widget>
                  : [widget.child],
            ),
          ),
        ],
      ),
    );
  }
}
