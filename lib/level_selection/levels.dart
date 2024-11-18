// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const gameLevels = [
  GameLevel(
    number: 1, // Level 1, four-letter words
    difficulty: 1,
    achievementIdIOS: 'four_letter_start',
    achievementIdAndroid: 'FourStrt123abc',
    letterCount: 4, // Associate level 1 with 4-letter words
  ),
  GameLevel(
    number: 2, // Level 2, five-letter words
    difficulty: 5,
    achievementIdIOS: 'first_win',
    achievementIdAndroid: 'NhkIwB69ejkMAOOLDb',
    letterCount: 5, // Associate level 2 with 5-letter words
  ),
  GameLevel(
    number: 3, // Level 2, five-letter words
    difficulty: 10,
    letterCount: 6, // Associate level 2 with 5-letter words
  ),
  GameLevel(
    number: 4, // Level 2, five-letter words
    difficulty: 20,
    letterCount: 7, // Associate level 2 with 5-letter words
  ),
];

class GameLevel {
  final int number;
  final int difficulty;
  final String? achievementIdIOS;
  final String? achievementIdAndroid;
  final int
      letterCount; // Add letterCount to determine word length for each level

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.number,
    required this.difficulty,
    required this.letterCount, // Accept letterCount in the constructor
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}
