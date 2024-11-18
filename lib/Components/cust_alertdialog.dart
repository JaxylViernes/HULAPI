import '../helpers/app_init.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'cust_fontstyle.dart';

class DialogHelper with Application {
  // #VALIDATION DIALOG
  static Future<void> showValidationDialog(
      BuildContext context, String title, String subtitle) {
    bool isDialogClosed = false;

    final dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      backgroundColor: AppColor().white,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColor().warning,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    AppImage().valid,
                    fit: BoxFit.contain,
                    scale: 5,
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    if (!isDialogClosed) {
                      Navigator.of(context).pop();
                      isDialogClosed = true;
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColor().white, width: 2),
                    ),
                    child: Center(
                      child: CustFontstyle(
                        label: 'X',
                        fontcolor: AppColor().white,
                        fontweight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 35, horizontal: 40),
            decoration: BoxDecoration(
              color: AppColor().white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustFontstyle(
                    label: title, fontsize: 20, fontweight: FontWeight.w600),
                Gap(10),
                CustFontstyle(
                    label: subtitle,
                    fontalign: TextAlign.center,
                    fontsize: 15,
                    fontweight: FontWeight.w400),
              ],
            ),
          ),
        ],
      ),
    );

    Future.delayed(Duration(milliseconds: 2000), () {
      if (!isDialogClosed) {
        Navigator.of(context).pop();
        isDialogClosed = true;
      }
    });

    return showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: false,
    );
  }

  // #GAMEOVER DIALOG
  static Future<void> showGameOverDialog(
      BuildContext context, String randWord, Function() onRepeat) {
    final dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular((10)),
        ),
      ),
      backgroundColor: AppColor().white,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: (300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColor().invalid,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      AppImage().invalid,
                      fit: BoxFit.contain,
                      scale: 5,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      onRepeat();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColor().white, width: 2),
                      ),
                      child: Center(
                        child: CustFontstyle(
                          label: 'X',
                          fontcolor: AppColor().white,
                          fontweight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: AppColor().white,
              padding: EdgeInsets.symmetric(vertical: (10), horizontal: (35)),
              child: Column(
                children: [
                  CustFontstyle(
                      label: 'Tapos na ang laro',
                      fontsize: 18,
                      fontweight: FontWeight.w600),
                  Gap((5)),
                  CustFontstyle(
                      label: 'GG! Ang tamang sagot ay',
                      fontalign: TextAlign.center,
                      fontsize: 15,
                      fontweight: FontWeight.w400),
                  Gap((10)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColor().valid, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      child: CustFontstyle(
                        label: randWord,
                        fontcolor: AppColor().darkGrey,
                        fontalign: TextAlign.center,
                        fontsize: 16,
                        fontweight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: (18), vertical: (10)),
                backgroundColor: AppColor().valid,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: CustFontstyle(
                label: 'Bumalik',
                fontsize: 15,
                fontweight: FontWeight.w600,
                fontcolor: AppColor().white,
              ),
            ),
            const Gap(25),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: (18), vertical: (10)),
                backgroundColor: AppColor().valid,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                onRepeat();
              },
              child: CustFontstyle(
                label: 'Ulitin',
                fontsize: 15,
                fontweight: FontWeight.w600,
                fontcolor: AppColor().white,
              ),
            ),
          ],
        ),
      ],
    );
    return showDialog(context: context, builder: (_) => dialog);
  }

  // #RESET SYSTEM
  static Future<void> showResetDialog(
      BuildContext context, String title, String subtitle, Function() onReset) {
    final dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular((10)),
        ),
      ),
      backgroundColor: AppColor().white,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: (300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColor().invalid,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    size: 80,
                    color: AppColor().white,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColor().white, width: 2),
                      ),
                      child: Center(
                        child: CustFontstyle(
                          label: 'X',
                          fontcolor: AppColor().white,
                          fontweight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: AppColor().white,
              padding: EdgeInsets.symmetric(vertical: (15), horizontal: (35)),
              child: Column(
                children: [
                  Gap((10)),
                  CustFontstyle(
                      label: title, fontsize: 18, fontweight: FontWeight.w600),
                  Gap((5)),
                  CustFontstyle(
                      label: subtitle,
                      fontalign: TextAlign.center,
                      fontsize: 15,
                      fontweight: FontWeight.w400),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: (18), vertical: (10)),
                backgroundColor: AppColor().no,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CustFontstyle(
                label: 'kanselahin',
                fontsize: 15,
                fontweight: FontWeight.w600,
                fontcolor: AppColor().white,
              ),
            ),
            const Gap(25),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: (18), vertical: (10)),
                backgroundColor: AppColor().valid,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onReset();
              },
              child: CustFontstyle(
                label: 'Ituloy',
                fontsize: 15,
                fontweight: FontWeight.w600,
                fontcolor: AppColor().white,
              ),
            ),
          ],
        ),
      ],
    );
    return showDialog(context: context, builder: (_) => dialog);
  }
}
