import 'package:dsassign/postsearch.dart';
import 'package:dsassign/profilesearch.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, initialIndex: 1, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mithilesh Ghadge Digital Shift'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              text: "Profile data",
            ),
            Tab(
              text: "Post data",
            )
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: tabController,
          children: const [
            ProfileSearchPage(), //  // home screen for Getting profile details
            PostSearchPage() // reel download Screen
          ],
        ),
      ),
    );
  }
}
