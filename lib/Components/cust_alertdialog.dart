import 'package:basic/utils/responsive.dart';
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
          Radius.circular(setResponsiveSize(context, baseSize: 10)),
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
                    topLeft: Radius.circular(
                        setResponsiveSize(context, baseSize: 10)),
                    topRight: Radius.circular(
                        setResponsiveSize(context, baseSize: 10)),
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
                right: setResponsiveSize(context, baseSize: 10),
                top: setResponsiveSize(context, baseSize: 10),
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
              borderRadius: BorderRadius.circular(
                  setResponsiveSize(context, baseSize: 10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustFontstyle(
                    label: title, fontsize: 20, fontweight: FontWeight.w600),
                Gap(setResponsiveSize(context, baseSize: 10)),
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
          Radius.circular((setResponsiveSize(context, baseSize: 10))),
        ),
      ),
      backgroundColor: AppColor().white,
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(setResponsiveSize(context, baseSize: 10)),
        ),
        width: (400),
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
                      topLeft: Radius.circular(
                          setResponsiveSize(context, baseSize: 10)),
                      topRight: Radius.circular(
                          setResponsiveSize(context, baseSize: 10)),
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
                  right: setResponsiveSize(context, baseSize: 10),
                  top: setResponsiveSize(context, baseSize: 10),
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
              decoration: BoxDecoration(
                color: AppColor().white,
                borderRadius: BorderRadius.circular(
                    setResponsiveSize(context, baseSize: 10)),
              ),
              padding: EdgeInsets.symmetric(vertical: (20), horizontal: (35)),
              child: Column(
                children: [
                  CustFontstyle(
                      label: 'Tapos na ang laro',
                      fontsize: 20,
                      fontweight: FontWeight.w600),
                  Gap(setResponsiveSize(context, baseSize: 5)),
                  CustFontstyle(
                      label: 'GG! Ang tamang sagot ay:',
                      fontalign: TextAlign.center,
                      fontsize: 16,
                      fontweight: FontWeight.w400),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: setResponsiveSize(context, baseSize: 15)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: CustFontstyle(
                        label: randWord.toUpperCase(),
                        fontcolor: AppColor().valid,
                        fontalign: TextAlign.center,
                        fontsize: 23,
                        fontweight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  setResponsiveSize(context, baseSize: 18),
                              vertical:
                                  (setResponsiveSize(context, baseSize: 10))),
                          backgroundColor: AppColor().valid,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.home, color: AppColor().white),
                      ),
                      Gap(25),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  setResponsiveSize(context, baseSize: 18),
                              vertical:
                                  (setResponsiveSize(context, baseSize: 10))),
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
                        child: Icon(Icons.restart_alt, color: AppColor().white),
                      ),
                      Gap(25),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  setResponsiveSize(context, baseSize: 18),
                              vertical:
                                  (setResponsiveSize(context, baseSize: 10))),
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
                        child: Icon(Icons.settings, color: AppColor().white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: false,
    );
  }

// #PAUSE DIALOG
  static Future<void> showPauseOverDialog(BuildContext context, String randWord,
      Function() onRepeat, Function() onReset) {
    final dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular((setResponsiveSize(context, baseSize: 10))),
        ),
      ),
      backgroundColor: AppColor().white,
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(setResponsiveSize(context, baseSize: 10)),
        ),
        width: (400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColor().valid,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          setResponsiveSize(context, baseSize: 10)),
                      topRight: Radius.circular(
                          setResponsiveSize(context, baseSize: 10)),
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
                  right: setResponsiveSize(context, baseSize: 10),
                  top: setResponsiveSize(context, baseSize: 10),
                  child: GestureDetector(
                    onTap: () {
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
              decoration: BoxDecoration(
                color: AppColor().white,
                borderRadius: BorderRadius.circular(
                    setResponsiveSize(context, baseSize: 10)),
              ),
              padding: EdgeInsets.symmetric(vertical: (20), horizontal: (35)),
              child: Column(
                children: [
                  CustFontstyle(
                      label: 'Ihinto ang laro',
                      fontsize: 20,
                      fontweight: FontWeight.w600),
                  Gap(setResponsiveSize(context, baseSize: 5)),
                  CustFontstyle(
                      label: 'Pahinga muna, balikan ang laro mamaya.',
                      fontalign: TextAlign.center,
                      fontsize: 16,
                      fontweight: FontWeight.w400),
                  Gap(setResponsiveSize(context, baseSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  setResponsiveSize(context, baseSize: 18),
                              vertical:
                                  (setResponsiveSize(context, baseSize: 10))),
                          backgroundColor: AppColor().valid,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.home, color: AppColor().white),
                      ),
                      Gap(20),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  setResponsiveSize(context, baseSize: 20),
                              vertical:
                                  setResponsiveSize(context, baseSize: 15)),
                          backgroundColor: AppColor().valid,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          onRepeat();
                        },
                        child: Icon(Icons.play_arrow_rounded,
                            color: AppColor().white),
                      ),
                      Gap(20),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  setResponsiveSize(context, baseSize: 18),
                              vertical:
                                  (setResponsiveSize(context, baseSize: 10))),
                          backgroundColor: AppColor().valid,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          onReset();
                        },
                        child: Icon(Icons.restart_alt, color: AppColor().white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return showDialog(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: false,
    );
  }

  // #RESET SYSTEM
  static Future<void> showResetDialog(
      BuildContext context, String title, String subtitle, Function() onReset) {
    final dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(setResponsiveSize(context,
              baseSize: setResponsiveSize(context, baseSize: 10))),
        ),
      ),
      backgroundColor: AppColor().white,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: setResponsiveSize(context, baseSize: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: setResponsiveSize(context, baseSize: 120),
                  decoration: BoxDecoration(
                    color: AppColor().invalid,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          setResponsiveSize(context, baseSize: 10)),
                      topRight: Radius.circular(
                          setResponsiveSize(context, baseSize: 10)),
                    ),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    size: setResponsiveSize(context, baseSize: 80),
                    color: AppColor().white,
                  ),
                ),
                Positioned(
                  right: setResponsiveSize(context, baseSize: 10),
                  top: setResponsiveSize(context, baseSize: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: setResponsiveSize(context, baseSize: 30),
                      width: setResponsiveSize(context, baseSize: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            setResponsiveSize(context, baseSize: 5)),
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
              padding: EdgeInsets.symmetric(
                  vertical: setResponsiveSize(context), horizontal: (35)),
              child: Column(
                children: [
                  Gap((setResponsiveSize(context, baseSize: 10))),
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
                padding: EdgeInsets.symmetric(
                    horizontal: setResponsiveSize(context, baseSize: 18),
                    vertical: (setResponsiveSize(context, baseSize: 10))),
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
            Gap(25),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: setResponsiveSize(context, baseSize: 18),
                    vertical: (setResponsiveSize(context, baseSize: 10))),
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
