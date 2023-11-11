import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_icon_button.dart';

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            backgroundColor: appTheme.gray200,
            body: Container(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height,
                decoration: BoxDecoration(
                    color: appTheme.gray200,
                    image: DecorationImage(
                        image: AssetImage(ImageConstant.imgLandingPage),
                        fit: BoxFit.cover)),
                child: Container(
                    width: 360,
                    padding: EdgeInsets.symmetric(horizontal: 23, vertical: 28),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [const Spacer(), _buildTeks(context)])))));
  }

  /// Section Widget
  Widget _buildTeks(BuildContext context) {
    return SizedBox(
        height: 180,
        width: 285,
        child: Stack(alignment: Alignment.bottomLeft, children: [
          Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                  width: 185,
                  child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Discover",
                            style: CustomTextStyles
                                .displayMediumEncodeSansSemiCondensed),
                        TextSpan(
                            text: "\nYour World with ",
                            style: CustomTextStyles
                                .titleLargeEncodeSansSemiCondensedOnPrimary),
                      ]),
                      textAlign: TextAlign.left))),
          Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                  width: 240,
                  child: Text(
                      "Tripper, Your Passport to Unforgettable Journeys. One place at a time.",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles
                          .bodyMediumEncodeSansSemiCondensedOnPrimary
                          .copyWith(height: 1.62)))),
          Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 6),
              child: CustomIconButton(
                  height: 37,
                  width: 37,
                  padding: EdgeInsets.all(2),
                  alignment: Alignment.bottomRight,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  child:
                      CustomImageView(imagePath: ImageConstant.imgArrowRight))),
          CustomImageView(
              imagePath: ImageConstant.imgLogoTripperWhite,
              height: 66,
              width: 135,
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 37))
        ]));
  }
}
