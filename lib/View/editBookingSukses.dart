import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';

class EditBookingSukses extends StatelessWidget {
  const EditBookingSukses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Container(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(0.5, 0),
                        end: Alignment(0.5, 1),
                        colors: [
                      theme.colorScheme.primary,
                      appTheme.indigo200
                    ])),
                child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(left: 50, top: 140, right: 50),
                    child: Column(children: [
                      CustomImageView(
                          imagePath: ImageConstant.tripperbumi,
                          height: 120,
                          width: 130),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Edit Booking",
                              style: CustomTextStyles.titleBookingSukses)),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Successfull",
                              style: theme.textTheme.displaySmall)),
                      SizedBox(height: 10),
                      SizedBox(
                          width: 250,
                          child: Text(
                              "Tanggal Start perjalanan anda sudah di-update.",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: CustomTextStyles.labelBookingSukses))
                    ]))),
            bottomNavigationBar: _buildBackToHome(context)));
  }

  /// Section Widget
  Widget _buildBackToHome(BuildContext context) {
    return CustomElevatedButton(
        text: "OK",
        textColor: theme.colorScheme.primary,
        margin: EdgeInsets.only(left: 40, right: 34, bottom: 16),
        onPressed: () {
          Navigator.popUntil(context, (route) {
            return route.settings.name == AppRoutes.homeUser;
          });
        });
  }
}
