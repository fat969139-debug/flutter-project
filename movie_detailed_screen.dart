import 'package:cached_network_image/cached_network_image.dart';//مكتبة تحميل الصور من النت
import 'package:flutter/material.dart';//مكتبة مهمة في فلاتر فيها widgets
import 'package:netflix_app/Common/utils.dart';
import 'package:netflix_app/Model/movie_details.dart';
import 'package:netflix_app/Model/movie_recommendation.dart';
import 'package:netflix_app/Services/api_services.dart';

class MovieDetailedScreen extends StatefulWidget {
  //المتغيرات الي جايه من الشاشة السابقة (بيانات الفيلم )
  final String posterPath;
  final String title;
  final String overview;
  final String releaseDate;
  final String originalLanguage;
  final int movieId;
  //نعبي في هذه المتغيرات و لازم يكون في بيانات (required)
  const MovieDetailedScreen({
    super.key,
    required this.movieId,
    required this.posterPath,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.originalLanguage,
  });

  @override
  State<MovieDetailedScreen> createState() => _MovieDetailedScreenState();//نلربط في الشاشة بال state متعها
}

class _MovieDetailedScreenState extends State<MovieDetailedScreen> {
  final ApiServices apiServices = ApiServices();
  late Future<MovieDetail?> moviwDetail;//للتفاصيل
  late Future<MovieRecommeddations?> movieRecommendation;//للافلام المتشابهة

  @override
  void initState() {
    fetchMovieData();//دالة وظيفتها تعبي المتغيرات بالبيانات من ال api
    super.initState();
  }

  fetchMovieData() async {//دالة الجلب و هيا غير متزامنة اي تستنى البيانات من النت بدون توقف تشغيل البرنامج
    moviwDetail = apiServices.movieDetail(widget.movieId);
    movieRecommendation = apiServices.movieRecommendation(widget.movieId);
    setState(() {}); //callback فارغ لان المتغيرات تعبت فوق
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery//نستخدم فيها للحصول على حجم الشاشة الكاملة
        .of(context)
        .size;
     return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(//يسمح بالتمرير العمودي
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,//العناصر تبدأ من اليسار
          children: [
            Stack(//يسمح بوضع العناصر فوق بعض
              children: [
                Container(//يعرض الصورة
                  height: size.height * 0.4,//40% من الشاشة
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(//يحمل في الصورة من النت
                        "$imageUrl${widget.posterPath}",
                      ),
                    ),
                  ),
                ),
                //الايقونات التي تظهر على الصورة
                Positioned(
                  right: 15,
                  top: 50,
                  child: Row(
                    children: [
                      CircleAvatar(//يعطي شكل دائرة للخلفية
                        backgroundColor: Colors.black54,
                        child: GestureDetector(
                          onTap: Navigator
                              .of(context)
                              .pop,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.cast, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(//الايقونة الي في المنتصف
                  top: 100,
                  bottom: 100,
                  right: 100,
                  left: 100,
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(//لتحديد نسبة مساحة كل عنصر داخل الصف
                        flex: 7,//الصف ياخد 70% من المساحه
                        child: Text(
                          widget.title,
                          // movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,//لو النص اطول من المساحة نستبدلها ب نقاط  ....
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,//باقي المساحة للصورة
                        child: Image.asset(
                          "assets/netflix.png",
                          height: 80,
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                  Row(//تاريخ الاصدار
                    children: [
                      Text(
                        widget.releaseDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text( // و اللغة
                        widget.originalLanguage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "HD",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 30, color: Colors.black),
                    Text(
                      "Play",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download, size: 30, color: Colors.white),
                    Text(
                      "Download",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            //يعرض ملخص الفيلم
            Text(
              widget.overview,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),

            SizedBox(height: 10),
            //صف مقسوم لتلاتة اعمده
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.add, size: 45, color: Colors.white),
                    Text(
                      "My List",
                      style: TextStyle(color: Colors.white, height: 0.5),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.thumb_up, size: 40, color: Colors.white),
                    Text(
                      "Rate",
                      style: TextStyle(color: Colors.white, height: 0.5),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.share, size: 40, color: Colors.white),
                    Text(
                      "Share",
                      style: TextStyle(color: Colors.white, height: 0.5),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            FutureBuilder(
              future: movieRecommendation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {//لو جبت بيانات
                  final movie = snapshot.data;
                  return movie!.results.isEmpty//التحقق من وجود بيانات  اذا لاتوجد بيانات
                      ? SizedBox()//لا يعرض شي
                      : Column(// وهذه اذا وجدت
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "More Like This",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(//قائمة افقية
                          scrollDirection: Axis.horizontal,//يمكن التمرير
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: movie.results.length,
                          itemBuilder: (context, index) {

                            return Padding(
                              padding: const EdgeInsets.only(right: 5),//مسافة بين كل صورة
                              child: CachedNetworkImage(
                                imageUrl:
                                "$imageUrl${movie.results[index].posterPath}",
                                height: 200,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Text("Something Went Wrong");
              },
            ),
          ],
        ),
      ),
    );
  }

}
