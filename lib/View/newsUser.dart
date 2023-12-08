import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custome_news.dart';
import 'package:ugd1/View/news.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';

//ini masih salah deh kayanya
class NewsPage extends StatelessWidget {
  // final NewsData newsData;

  const NewsPage({Key? key}) : super(key: key);

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
              _buildRowTuguYogyakarta(context),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 19),
                  child: Text(
                    "Overview",
                    style: CustomTextStyles.labelLarge12,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 19),
                child: SingleChildScrollView(
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
                    style: TextStyle(
                      color: Colors
                          .black, // Ubah warna teks jika latar belakangnya terlalu terang
                      fontSize: 16, // Ubah ukuran teks jika perlu
                    ),
                    textAlign: TextAlign
                        .justify, // Atur penataan teks agar rata kanan kiri
                  ),
                ),
              ),
              SizedBox(height: 18),
              _buildListAndroidLargeSix(context),
              SizedBox(height: 23),
              CustomElevatedButton(
                text: "Add Your Photos",
                margin: EdgeInsets.symmetric(horizontal: 19),
                onPressed: () {
                  // Tambahkan logika ketika tombol ditekan di sini
                },
              ),
              SizedBox(height: 5),
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
              alignment: Alignment.topCenter,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                  decoration: AppDecoration.fillGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder24),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 13),
                        CustomImageView(
                            imagePath: ImageConstant.imgArrowLeft,
                            height: 24,
                            width: 24,
                            onTap: () {
                              onTapImgArrowLeft(context);
                            })
                      ])))
        ]));
  }

  /// Section Widget
  Widget _buildRowTuguYogyakarta(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 19),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Tugu Yogyakarta", style: theme.textTheme.titleLarge),
                Text("Central Java", style: theme.textTheme.bodyMedium)
              ]),
              CustomImageView(
                  imagePath: ImageConstant.imgIconParkOutlineLike,
                  height: 31,
                  width: 31,
                  margin: EdgeInsets.only(bottom: 17))
            ]));
  }

  /// Section Widget
  Widget _buildListAndroidLargeSix(BuildContext context) {
    return SizedBox(
        height: 91,
        child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 19),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return SizedBox(width: 8);
            },
            itemCount: 3,
            itemBuilder: (context, index) {
              return CustomeNews();
            }));
  }

  /// Navigates back to the previous screen.
  onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
