import 'package:basic/helpers/app_init.dart';

import 'hive_helper.dart';
import '../models/letter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

Box getWordsBox(int letterCount) {
  switch (letterCount) {
    case 4:
      return HiveHelper.fourLetterWordsBox;
    case 5:
      return HiveHelper.fiveLetterWordsBox;
    case 6:
      return HiveHelper.sixLetterWordsBox;
    default:
      return HiveHelper.sevenLetterWordsBox;
  }
}

List<List<Letter>> generateRows(int totalLetters) {
  return List.generate(
    6,
    (index) => List.generate(
      totalLetters,
      (index) => Letter(letter: "", color: Application().color.white),
    ),
  );
}

String getCurrentWord(List<List<Letter>> rows, int currentRow) {
  return rows[currentRow].map((letter) => letter.letter).join();
}

void updateRow(List<List<Letter>> rows, int currentRow, String randomWord,
    String inputWord) {
  for (int i = 0; i < inputWord.length; i++) {
    final char = inputWord[i];
    final index = randomWord.indexOf(char);
    if (index == -1) {
      rows[currentRow][i].color = Color(0xFF787C7E); // Gray
    } else if (char == randomWord[i]) {
      rows[currentRow][i].color = Color(0xFF6AAA64); // Green
    } else {
      rows[currentRow][i].color = Color(0xFFC9B558); // Yellow
    }
  }
}

void addLetter(
    List<List<Letter>> rows, int currentRow, int currentCol, String letter) {
  if (currentCol < rows[currentRow].length) {
    rows[currentRow][currentCol].letter = letter;
  }
}

void deleteLetter(List<List<Letter>> rows, int currentRow, int currentCol) {
  if (currentCol > 0) {
    currentCol--;
    rows[currentRow][currentCol].letter = "";
  }
}
