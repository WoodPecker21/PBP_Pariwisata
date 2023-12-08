import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custome_news.dart';
import 'package:ugd1/View/news.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/client/newsClient.dart';
import 'package:ugd1/model/news.dart';

//ini masih salah deh kayanya, okeh
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int idnews = -1;
  News n = News();

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    final prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('idNews') ?? 0;
    print('id news dari halaman newsuser $id');

    setState(() {
      idnews = id;
    });

    //get the news from api
    try {
      if (id != -1) {
        final news = await NewsClient.find(idnews);

        setState(() {
          n.judul = news.judul ?? '';
          n.isiBerita = news.isiBerita ?? '';
          n.pengarang = news.pengarang ?? '';
        });
        print('retrieve news data ${n.judul}');
      } else {
        print('id news tidak ditemukan');
      }
    } catch (e) {
      print('error retrieve news data $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStackImage(context),
              SizedBox(height: 19),
              _buildRowTitlePengarang(n, context),
              SizedBox(height: 10),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: SingleChildScrollView(
                  child: Text(
                    n.isiBerita!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign
                        .justify, // Atur penataan teks agar rata kanan kiri
                  ),
                ),
              ),
              // SizedBox(height: 18),
              // _buildListAndroidLargeSix(context),
              SizedBox(height: 23),
              // CustomElevatedButton(
              //   text: "Add Your Photos",
              //   margin: EdgeInsets.symmetric(horizontal: 19),
              // ),
              // SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildStackImage(BuildContext context) {
    return SizedBox(
        height: 195,
        width: double.maxFinite,
        child: Stack(alignment: Alignment.topCenter, children: [
          CustomImageView(
              imagePath: ImageConstant.imgRectangle1036,
              height: 195,
              width: 360,
              radius: BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                  bottomLeft: Radius.circular(64),
                  bottomRight: Radius.circular(64)),
              alignment: Alignment.center),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ])))
        ]));
  }

  /// Section Widget
  Widget _buildRowTitlePengarang(News n, BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 19),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.judul!, style: theme.textTheme.titleLarge),
                Text(n.pengarang!, style: theme.textTheme.bodyMedium)
              ]),
              CustomImageView(
                  imagePath: ImageConstant.imgIconParkOutlineLike,
                  height: 31,
                  width: 31,
                  margin: EdgeInsets.only(bottom: 17))
            ]));
  }

  /// Section Widget
  // Widget _buildListAndroidLargeSix(BuildContext context) {
  //   return SizedBox(
  //       height: 91,
  //       child: ListView.separated(
  //           padding: EdgeInsets.symmetric(horizontal: 19),
  //           scrollDirection: Axis.horizontal,
  //           separatorBuilder: (context, index) {
  //             return SizedBox(width: 8);
  //           },
  //           itemCount: 3,
  //           itemBuilder: (context, index) {
  //             return CustomeNews();
  //           }));
  // }
}
