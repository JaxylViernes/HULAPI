import 'app_directory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

mixin class Application {
  AppImage get image => AppImage();
  AppColor get color => AppColor();
  AppGif get gif => AppGif();
  AppAvatar get avatar => AppAvatar();
}

class AppGif {
  String get warning => AppDirectory.gif('loading.gif');
  String get invalidated => AppDirectory.gif('loading.gif');
  String get validated => AppDirectory.gif('loading.gif');
}

class AppImage {
  String get invalid => AppDirectory.img('img_sad.png');
  String get valid => AppDirectory.img('img_happy.png');
  String get back => AppDirectory.img('img_background.png');
  String get START => AppDirectory.img('IMG_START.png');
  String get SPLASH => AppDirectory.img('IMG_SPLASH.png');
  String get CATEGORY => AppDirectory.img('IMG_CATEGORY.png');
  String get TROPE => AppDirectory.img('IMG_TROPE.png');

  String get SETUP => AppDirectory.img('IMG_SETUP.png');
  String get LEVEL => AppDirectory.img('IMG_LEVEL.png');
  String get BACK1 => AppDirectory.img('IMG_BACK1.png');
  String get BACK2 => AppDirectory.img('IMG_BACK2.png');
  String get BACK3 => AppDirectory.img('IMG_BACK3.png');
  String get BACK4 => AppDirectory.img('IMG_BACK4.png');
}

class AppAvatar {
  String get avatar1 => AppDirectory.avatar('AVATAR1.png');
  String get avatar2 => AppDirectory.avatar('AVATAR2.png');
  String get avatar3 => AppDirectory.avatar('AVATAR3.png');
  String get avatar4 => AppDirectory.avatar('AVATAR4.png');
  String get avatar5 => AppDirectory.avatar('AVATAR5.png');
  String get avatar6 => AppDirectory.avatar('AVATAR6.png');
}

class AppColor {
  Color get darklight => const Color(0xFF5B5B5B);
  Color get black => const Color(0xFF000000);

  Color get dark => const Color(0xFF333333);
  Color get darkGrey => const Color(0xFF808080);
  Color get lightGrey => const Color(0xFFDBDBDB);
  Color get valid => const Color(0xFF6AAA64);
  Color get warning => const Color(0xFFC9B558);
  Color get invalid => const Color(0xFFFF7951);
  Color get blue => const Color(0xFF78B3CE);
  Color get white => const Color(0xFFFFFFFF);
  Color get yes => const Color(0xFF99E661);
  Color get no => const Color(0xFFFF8F91);
  Color get yellow => const Color(0xFFFFC500);
}
