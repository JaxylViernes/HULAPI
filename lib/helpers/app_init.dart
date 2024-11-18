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

  Color get dark => const Color(0xFF333333);
  Color get darkGrey => const Color(0xFF808080);
  Color get lightGrey => const Color(0xFFDBDBDB);
  Color get valid => const Color(0xFF6AAA64);
  Color get warning => const Color(0xFFC9B558);
  Color get invalid => const Color(0xFFFF7951);
  Color get blue => const Color(0xFF0175C2);
  Color get white => const Color(0xFFFFFFFF);
  Color get yes => const Color(0xFF99E661);
  Color get no => const Color(0xFFFF8F91);
}
