class AppDirectory {
  // ignore: constant_identifier_names
  static const String _IMG = 'assets/images/';
  // ignore: constant_identifier_names
  static const String _ICON = 'assets/icons/';
  // ignore: constant_identifier_names
  static const String _GIF = 'assets/gifs/';
  // ignore: constant_identifier_names
  static const String _Avatar = 'assets/avatar/';

  static String avatar(String file) {
    return _Avatar + file;
  }

  static String img(String file) {
    return _IMG + file;
  }

  static String icon(String file) {
    return _ICON + file;
  }

  static String gif(String file) {
    return _GIF + file;
  }
}
