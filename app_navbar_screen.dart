import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:netflix_app/Screen/hot_news.dart';
import 'package:netflix_app/Screen/netflix_home_screen.dart';
import 'package:netflix_app/Screen/search_screen.dart';

class AppNavbarScreen extends StatelessWidget {
  const AppNavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(//المنظم الذي يربط الازرار التي بالاسفل مع الصفحات
      length: 3,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 70,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Iconsax.home5), text: "Home"),
              Tab(icon: Icon(Iconsax.search_normal), text: "Search"),
              Tab(icon: Icon(Icons.photo_library_outlined), text: "Hot News"),
            ],
            unselectedLabelColor: Colors.grey,//لون الايقونة الغير مختاره
            labelColor: Colors.white,//وهذه المختارة
            indicatorColor: Colors.transparent,
          ),
        ),
        body: TabBarView(//الشاشات اللي تنعرض بالترتيب متع الازرار
          children: [NetflixHomeScreen(), SearchScreen(), HotNews()],
        ),
      ),
    );
  }
}
