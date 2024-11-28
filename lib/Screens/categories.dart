import 'package:basic/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basic/Components/cust_fontstyle.dart';
import '../helpers/app_init.dart';
import '../style/responsive_screen.dart';

class LanguageSelectionScreen extends StatelessWidget with Application {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            AppImage().CATEGORY, // Replace with your asset for this screen
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          // Content
          Positioned(
            bottom: setResponsiveSize(context, baseSize: 100),
            left: setResponsiveSize(context, baseSize: 20),
            right: setResponsiveSize(context, baseSize: 20),
            child: Column(
              children: [
                // Title
                CustFontstyle(
                  label: 'Pumili ng Categorya',
                  fontsize: setResponsiveSize(context, baseSize: 25),
                  fontcolor: color.white,
                  fontweight: FontWeight.w700,
                ),
                SizedBox(height: setResponsiveSize(context, baseSize: 50)),

                // Cebuano Button
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/play', extra: 'Tagalog');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                    backgroundColor: AppColor().yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: AppColor().white, width: 4),
                    ),
                  ),
                  child: CustFontstyle(
                    label: 'Tagalog',
                    fontsize: 25,
                    fontcolor: AppColor().black,
                    fontweight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: setResponsiveSize(context, baseSize: 20)),

                // Cebuano Button

                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/cebuano', extra: 'Cebuano');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                    backgroundColor: AppColor().yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: AppColor().white, width: 4),
                    ),
                  ),
                  child: CustFontstyle(
                    label: 'Bisaya',
                    fontsize: 25,
                    fontcolor: AppColor().black,
                    fontweight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: setResponsiveSize(context, baseSize: 100)),

                // Back Button
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/main');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 50),
                    backgroundColor: AppColor().yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: AppColor().white, width: 4),
                    ),
                  ),
                  child: CustFontstyle(
                    label: 'Bumalik',
                    fontsize: 25,
                    fontcolor: AppColor().black,
                    fontweight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
