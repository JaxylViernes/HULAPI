import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String fourLetterWords = 'four_letter_words';
  static const String fiveLetterWords = 'five_letter_words';
  static const String sixLetterWords = 'six_letter_words';
  static const String sevenLetterWords = 'seven_letter_words';

  static const String cebuanofourLetterWords = 'cebuanofour_letter_words';
  static const String cebuanofiveLetterWords = 'cebuanofive_letter_words';
  static const String cebuanosixLetterWords = 'cebuanosix_letter_words';
  static const String cebuanosevenLetterWords = 'cebuanoseven_letter_words';

  static late Box fourLetterWordsBox;
  static late Box fiveLetterWordsBox;
  static late Box sixLetterWordsBox;
  static late Box sevenLetterWordsBox;

  static late Box cebuanofourLetterWordsBox;
  static late Box cebuanofiveLetterWordsBox;
  static late Box cebuanosixLetterWordsBox;
  static late Box cebuanosevenLetterWordsBox;
  static Future<void> init() async {
    await Hive.initFlutter();
    fourLetterWordsBox = await Hive.openBox(fourLetterWords);
    fiveLetterWordsBox = await Hive.openBox(fiveLetterWords);
    sixLetterWordsBox = await Hive.openBox(sixLetterWords);
    sevenLetterWordsBox = await Hive.openBox(sevenLetterWords);

    cebuanofourLetterWordsBox = await Hive.openBox(cebuanofourLetterWords);
    cebuanofiveLetterWordsBox = await Hive.openBox(cebuanofiveLetterWords);
    cebuanosixLetterWordsBox = await Hive.openBox(cebuanosixLetterWords);
    cebuanosevenLetterWordsBox = await Hive.openBox(cebuanosevenLetterWords);
  }

  static bool isWord(String word, Box box) {
    final listWords = box.values.toList().cast<String>();
    for (var word1 in listWords) {
      final trimmedWord = word1.trim();
      if (trimmedWord == word) {
        return true;
      }
    }
    return false;
  }

  static String randomWord(int letterCount, Box box) {
    final listWords = box.values.toList().cast<String>();
    if (listWords.isEmpty) {
      return '';
    }
    final randomIndex = Random().nextInt(listWords.length);
    return listWords[randomIndex].trim();
  }
}
