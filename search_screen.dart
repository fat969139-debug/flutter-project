import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_app/Common/utils.dart';
import 'package:netflix_app/Model/search_moviee.dart';
import 'package:netflix_app/Model/trending_movei.dart';
import 'package:netflix_app/Screen/movie_detailed_screen.dart';
import 'package:netflix_app/Services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ApiServices apiServices = ApiServices();
  TextEditingController searchController = TextEditingController();//يتحكم في شريط البحث
  late Future<TrendingMovies?> trendingMovie;
  SearchMovie? searchMovie;//يخزن نتائج البحث عند كتابة المستخدم
 //دالة البحث
  void search(String query) {
    apiServices.searchMovie(query).then((result) {//ترسل الكلمة الي كتبها المستخدم الى api و بعد ماتجي النتائج تتحدث حالة الشاشة
      setState(() {
        searchMovie = result;
      });
    });
  }

  @override
  void initState() {
    trendingMovie = apiServices.trendingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoSearchTextField(//صندوق البحث
              controller: searchController,
              padding: EdgeInsets.all(10),
              prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
              suffixIcon: Icon(Icons.cancel, color: Colors.grey),
              style: TextStyle(color: Colors.white),
             backgroundColor: Colors.grey.withOpacity(0.3),
              onChanged: (value) { //كل مايكتب المستخدم شيء يتم البحث مباشره
                if (value.isEmpty) {
                }
                else {
                  search(searchController.text);
                }
              },
            ),
            SizedBox(height: 10),
            searchController.text.isEmpty//لو المستخدم لم يكتب شي نعرض الافلام الترند
                ? FutureBuilder(
                  future: trendingMovie,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final movie = snapshot.data?.results;
                      //لترتيب العناصر عموديا
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Text(
                            "Top Search",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),//تمنع التمرير
                            shrinkWrap: true,//ايخلي الطول يتوافق مع عدد العناصر
                            padding: EdgeInsets.zero,
                            itemCount: movie!.length,
                            //دالة تحدد شكل كل صف
                            itemBuilder: (context, index) {
                              final topMovie = movie[index];//يمتل الفيلم الحالي
                              return Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: InkWell(//يخلي الصف قابل للنقر
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    MovieDetailedScreen(
                                                      movieId: topMovie.id,
                                                       originalLanguage:
                                                      topMovie.originalLanguage.toString(),
                                                      posterPath: topMovie.backdropPath,
                                                      title: topMovie.title,
                                                      overview: topMovie.overview,
                                                      releaseDate: topMovie.releaseDate.year.toString(),
                                                    ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl:
                                                  "$imageUrl${topMovie.backdropPath}",
                                              fit: BoxFit.contain,
                                              width: 150,
                                            ),
                                            SizedBox(width: 20),
                                            Flexible(//يجعل النص يصغر لو مافيش مساحة
                                              child: Text(
                                                topMovie.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  //وضع ايقونة
                                  Positioned(
                                    right: 20,
                                    top: 40,
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                )
                : searchMovie == null
                ? SizedBox.shrink()//لو ماكانش شريط البحث فارغ لكن لاتوجد نتائج لا يعرض شي

                : ListView.builder(
                  padding: EdgeInsets.zero,// لايوجد مسافات
                  shrinkWrap: true,//طول القائمة يتناسب مع عدد العناصر
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: searchMovie?.results.length,
                  itemBuilder: (context, index) {

                    final search = searchMovie!.results[index];
                    return search.backdropPath == null
                        ? SizedBox()
                        : Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => MovieDetailedScreen(
                                            movieId: search.id,
                                             originalLanguage:
                                                search.originalLanguage,
                                            posterPath: search.backdropPath.toString(),
                                            title: search.title,
                                            overview: search.overview,
                                            releaseDate:
                                                search.releaseDate.year
                                                    .toString(),
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            "$imageUrl${search.backdropPath}",
                                        fit: BoxFit.contain,
                                        width: 150,
                                      ),
                                      SizedBox(width: 20),
                                      Flexible(
                                        child: Text(
                                          search.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 40,
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                          ],
                        );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
