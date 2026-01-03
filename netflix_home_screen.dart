import 'package:cached_network_image/cached_network_image.dart';//لتحميل الصور من الانترنت و تخزينها لتسريع الاداء
import 'package:flutter/material.dart';// المكتبة الاساسية لبناء واجهات flutter المستخدمة
import 'package:netflix_app/Common/utils.dart';
import 'package:netflix_app/Model/movie_model.dart';
import 'package:netflix_app/Model/poplar_tv_series.dart';
import 'package:netflix_app/Model/top_rated_movies.dart';
import 'package:netflix_app/Model/trending_movei.dart';
import 'package:netflix_app/Model/upcoming_movie_model.dart';
import 'package:netflix_app/Screen/movie_detailed_screen.dart';
import 'package:netflix_app/Screen/search_screen.dart';
import 'package:netflix_app/Services/api_services.dart';

class NetflixHomeScreen extends StatefulWidget {//تجعل الشاشة قادرة على التغير اثناء التشغيل
  const NetflixHomeScreen({super.key});

  @override
  State<NetflixHomeScreen> createState() => _NetflixHomeScreenState();
}

class _NetflixHomeScreenState extends State<NetflixHomeScreen> {
  final ScrollController _scrollController = ScrollController();//تسمح بتحريك الشاشة عموديا
  final ApiServices apiServices = ApiServices();
  late Future<Movie?> movieData;  // متغيرات سوف يتم تعيين القيمة لاحقا
  late Future<UpcomingMovies?> upcomingMovies;
  late Future<TopRatedMovies?> topRatedMovies;
  late Future<TrendingMovies?> trendingMovies;
  late Future<PopularTVseries?> popularTVseries;
  @override
  void initState() {//جلب البيانات من api
    movieData = apiServices.fetchMovies();
    upcomingMovies = apiServices.upcomingMovies();
    topRatedMovies = apiServices.topRatedMovies();
    trendingMovies = apiServices.trendingMovies();
    popularTVseries = apiServices.popularTvSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(//لتفعيل التحريك العمودي للشاشة
        controller: _scrollController,//لتحريك الصفحة برمجيا و قمنا بتعريفه فوق
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Image.asset("assets/logo.png", height: 50),
                  Spacer(),//يبعد العناصر الي اليمين
                  IconButton(
                    onPressed: () {//Anonymous Function++
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreen()),
                      );
                    },
                    icon: Icon(Icons.search, size: 27, color: Colors.white),
                  ),
                  Icon(Icons.download_sharp, size: 27, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.cast, size: 27, color: Colors.white),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),//مسافة جانبية
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      _scrollController.animateTo(
                        700,
                        duration: Duration(milliseconds: 100),//تحديد مدى الحركة
                        curve: Curves.bounceIn,//تأتير على الbtn
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white38),
                    ),
                    child: Text(
                      "TV Shows",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  MaterialButton(
                    onPressed: () {
                      _scrollController.animateTo(
                        300,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white38),
                    ),
                    child: Text(
                      "Movies",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  MaterialButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.black, // خلفية داكنة
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // حواف مستديرة
                        ),
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                             mainAxisSize: MainAxisSize.min,//ياخد فقط المسافة الازمة لا يمتد ليملأ الشاشة
                              children: [
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(color: Colors.white38), // خط فاصل
                                ListTile(
                                  title: Text("Action", style: TextStyle(color: Colors.white)),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text("Comedy", style: TextStyle(color: Colors.white)),
                                  onTap: () { Navigator.pop(context); },
                                ),
                                ListTile(
                                  title: Text("Drama", style: TextStyle(color: Colors.white)),
                                  onTap: () { Navigator.pop(context); },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white38),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white),//السهم
                      ],
                    ),
                  ),
                  SizedBox(width: 8),//مسافات حول العناصر
                ],
              ),
            ),
            SizedBox(height: 10), //مسافات رأسية

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),//مسافة جانبية
              child: Stack(//يسمح بوضع العناصر فوق بعض
                clipBehavior: Clip.none,//العناصر يمكن ان تتجاوز الحدود بدون ان تقص
               //لعرض الفيلم
                children: [
                  Container(
                    height: 530,
                    width: double.maxFinite,//يمتد ليملأ العرض المتاح
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: FutureBuilder(//يعرض محتوى الفيلم بعد تحميله من ال api
                      future: movieData,
                      builder: (context, snapshot) {//دالة تحدد كيف تظهر الشاشة حسب حالة البيانات
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());//دائرة التحميل
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),//او يعرض ال error
                          );
                        } else if (snapshot.hasData) {
                          final movies = snapshot.data!.results;//او يعرض البيانات
                          return ClipRRect(//الحواف دائرية
                            borderRadius: BorderRadius.circular(20),

                            child: PageView.builder(//يدير صفحات يمكن السحب بينها افقيا
                              itemCount: movies.length,
                              scrollDirection: Axis.horizontal,//التمرير افقيا (يمين /يسار )
                              itemBuilder: (context, index) {//دالة تبني كل صفحة حسب ال index
                                final movie = movies[index];
                                return GestureDetector(//للضغط على الفيلم اي يجعل كل صفحة قابلة للنقر
                                  onTap: () {
                                    Navigator.push(//فتح الشاشة الجديدة مع امكانية العودة للشاشة الرئيسية
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => MovieDetailedScreen(
                                              movieId: movie.id, //البيانات الي بنقوم بتمريرها الي صفحة التفاصيل
                                              posterPath:
                                                  movie.backdropPath.toString(),
                                                  title: movie.title,
                                                  overview: movie.overview,
                                                   originalLanguage:
                                                     movie.originalLanguage,
                                                     releaseDate:
                                                       movie.releaseDate.year
                                                       .toString(),
                                            ),
                                      ),
                                    );
                                  },
                                  //يعرض البيانات بعد التحميل
                                  child: Container(
                                    height: 530,
                                    width: 388,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          "$imageUrl${movie.posterPath}",
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(child: Text("Problem to fetch data"));
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 50,//ال padding من الجانبين
                            width: 150,//الpadding  من الاعلى و الاسفل
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                Text(
                                  "Play",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 30),
                                Text(
                                  "My List",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            moviesTypes(
              future: trendingMovies,//api الي بيحمل البيانات
              movieType: "Trending Movies on Netflix",
              isTv: false,
            ),
            moviesTypes(
              future: upcomingMovies,
              movieType: "Upcoming Movies",
              isReverse: true,
                isTv: false,
            ),
            moviesTypes(
              future: popularTVseries,
              movieType: "Popular TV Series - Most-Watch For You",
                isTv: true,
            ),
            moviesTypes(future: topRatedMovies, movieType: "Top Rated Movies"),
          ],
        ),
      ),
    );
  }

  Padding moviesTypes({
    required Future future,
    required String movieType,
    bool isReverse = false,//يعكس ترتيب الافلام
    bool isTv = false, // لو مسلسل ماتنفتحش شاشة التفاصيل
  })

  {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,//يخلي العناصر على جيهة اليسار
        children: [
          Text(
            movieType,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 180,
            width: double.maxFinite,//ياخد كل عرض الشاشة

            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {//دالة تقرر شن تعرض على حسب نوع البيانات
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());//حالة التحميل
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                  //في حالة نجاح البيانات
                } else if (snapshot.hasData) {
                  final movies = snapshot.data!.results;
                  return ListView.builder(
                    reverse: isReverse,
                    itemCount: movies.length,
                    scrollDirection: Axis.horizontal,//تمرير افقي
                    itemBuilder: (context, index) {//كل فيلم منفصل
                      final movie = movies[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),//مسافة على اليمين
                        child: GestureDetector(//يخلي الفيلم قابل للنقر
                          onTap: () {
                            if (!isTv) { // ← هنا القرار
                              Navigator.push( //عند النقر يفتح شاشة التفصيل و يمرر البيانات الخاصة بالفيلم
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailedScreen(
                                    movieId: movie.id,
                                    posterPath: movie.backdropPath.isNotEmpty
                                        ? movie.backdropPath
                                        : movie.posterPath,
                                    title: movie.title,
                                    overview: movie.overview,//ملخص الفيلم
                                    originalLanguage: movie.originalLanguage.toString(),//لغة الفيلم الاصلية
                                    releaseDate: movie.releaseDate.year.toString(),//تاريخ الاصدار
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(//صورة الفيلم
                            width: 130,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,//الصورة تغطي الcontainer بالكامل
                                image: CachedNetworkImageProvider(//تحميل الصورة من النت
                                  "$imageUrl${movie.posterPath}",
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("Problem to fetch data"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
