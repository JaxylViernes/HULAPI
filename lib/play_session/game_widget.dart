import 'dart:async';
import 'dart:io';
import 'package:basic/Components/cust_alertdialog.dart';
import 'package:basic/game_internals/level_state.dart';
import 'package:basic/helpers/app_init.dart';
import 'package:basic/models/hiveAccount.dart';
import 'package:basic/utils/responsive.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../Components/cust_fontstyle.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../helpers/hive_helper.dart';
import '../models/letter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Components/cust_keyboard.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../Components/cust_letterbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key, required this.letterCount});
  final int letterCount;
  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class WordMeaningProvider {
  static String? cachedMeaning;
}

class _GameWidgetState extends State<GameWidget>
    with SingleTickerProviderStateMixin {
  late String randomWord;
  late List<List<Letter>> rows;
  late Box wordsBox;
  late int totalLetters;
  int currentCol = 0, currentRow = 0;
  bool isWordCorrect = false;
  Map<String, Color> keyColors = {};
  Timer? _timer;
  int _start = 300;
  bool hintUsed = false;
  String wordMeaning = '';
  bool _isPaused = false;
  int score = 100; // Initialize base score

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    totalLetters = 3 + widget.letterCount;
    wordsBox = _getWordsBox(totalLetters);
    randomWord = HiveHelper.randomWord(totalLetters, wordsBox).trim();
    rows = List.generate(
        6,
        (_) => List.generate(totalLetters,
            (_) => Letter(letter: "", color: const Color(0xffDBDBDB))));
    _startTimer();
    // Initialize the animation controller
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });
    // Initialize the shake animation
    _shakeAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(
          parent: _shakeController,
          curve: Curves.fastOutSlowIn), // Irregular curve
    );
  }

  void _useHint() {
    if (hintUsed) {
      DialogHelper.showValidationDialog(context, 'Paalala',
          'Isang paalala lang ang puwedeng gamitin sa bawat laro.');
      return;
    }
    score -= 10;
    for (int i = 0; i < totalLetters; i++) {
      if (rows[currentRow][i].letter.isEmpty) {
        rows[currentRow][i].letter = randomWord[i].toUpperCase();
        rows[currentRow][i].color = const Color(0xFF6AAA64);
        keyColors[randomWord[i].toUpperCase()] = const Color(0xFF6AAA64);
        hintUsed = true;
        break;
      }
    }
    setState(() {});
  }

  Box _getWordsBox(int letterCount) => letterCount == 4
      ? HiveHelper.fourLetterWordsBox
      : letterCount == 5
          ? HiveHelper.fiveLetterWordsBox
          : letterCount == 6
              ? HiveHelper.sixLetterWordsBox
              : HiveHelper.sevenLetterWordsBox;
  String _getCurrentWord() =>
      rows[currentRow].map((letter) => letter.letter).join();

  void _updateRow() {
    final inputWord = _getCurrentWord().toLowerCase();
    for (int i = 0; i < inputWord.length; i++) {
      final char = inputWord[i];
      final color = char == randomWord[i]
          ? Color(0xFF6AAA64)
          : (randomWord.contains(char) ? Color(0xFFC9B558) : Color(0xFF787C7E));
      rows[currentRow][i].color = color;
      keyColors[char.toUpperCase()] = color;
    }
    isWordCorrect = inputWord == randomWord;
  }

  void _addLetter(String letter) {
    if (currentCol < totalLetters) {
      rows[currentRow][currentCol++].letter = letter;
      setState(() {});
    }
  }

  void _deleteLetter() {
    if (currentCol > 0) {
      rows[currentRow][--currentCol].letter = "";
      setState(() {});
    }
  }

  void _submitWord() {
    if (currentRow < 6) {
      final inputWord = _getCurrentWord().toLowerCase();
      if (inputWord.isEmpty) {
        DialogHelper.showValidationDialog(context, 'Walang Letra',
            'Mangyaring pumili ng letra bago magpatuloy.');
      } else if (!HiveHelper.isWord(inputWord, wordsBox)) {
        DialogHelper.showValidationDialog(context, 'Maling Sagot',
            'Hindi tugma ang iyong sagot. Subukan muli.');

        print('ANSWER: ${randomWord}');
      } else {
        _updateRow();
        currentCol = 0;
        currentRow++;
        score -= 10;

        if (isWordCorrect) {
          score += 10;
          context.read<LevelState>().setProgress(100);
          context.read<AudioController>().playSfx(SfxType.wssh);
          context.read<LevelState>().evaluate();

          // Add bonus points based on time taken to guess
          if (_start <= 10) {
            score += 5; // Bonus for guessing within 10 seconds
          } else if (_start <= 20) {
            score += 3; // Bonus for guessing within 20 seconds
          } else if (_start <= 30) {
            score += 2; // Bonus for guessing within 30 seconds
          }

          Future.delayed(Duration(milliseconds: 600), () {
            _timer?.cancel();
            addScoreToPlayer(score);
            DialogHelper.showValidationDialog(context, 'Congratulations!',
                'You guessed the word! Your score is: $score');
            // You can also add additional logic here, such as navigating to a new screen or updating the game state
          });
        } else if (currentRow == 6 || _start == 0) {
          Future.delayed(Duration(milliseconds: 600), () {
            _timer?.cancel();
            WordMeaningProvider.cachedMeaning = null;
            DialogHelper.showGameOverDialog(context, randomWord, () {
              GoRouter.of(context).push('/play/session/${widget.letterCount}');
            });
          });
        }
      }
      setState(() {});
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _timer?.cancel();
        Future.delayed(Duration(milliseconds: 600), () {
          WordMeaningProvider.cachedMeaning = null;
          DialogHelper.showGameOverDialog(context, randomWord, () {
            GoRouter.of(context).push('/play/session/${widget.letterCount}');
          });
        });
      } else {
        setState(() {
          _start--;
        });

        // Add bonus points if the word is guessed within a time frame
        if (_start == 10) {
          // Add bonus points if guessed within 10 seconds
          score += 5;
        } else if (_start == 20) {
          // Add bonus points if guessed within 20 seconds
          score += 3;
        } else if (_start == 30) {
          // Add bonus points if guessed within 30 seconds
          score += 2;
        }

        // Trigger shake animation when timer is near 30 seconds
        if (_start <= 10) {
          if (!_shakeController.isAnimating) {
            _shakeController.forward();
          }
        }
      }
    });
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Android ID as device identifier
      print('Running on ${androidInfo.model}');
    }
    return deviceId;
  }

  Future<String?> addScoreToPlayer(int additionalScore) async {
    try {
      // Get the device ID (assuming you have a method to fetch this)
      String deviceId = await getDeviceId();

      // Open the Hive box to retrieve player data
      var box = await Hive.openBox<HiveAccount>('players');

      // Retrieve the player model from Hive using the device ID
      var playerModel = box.get(deviceId);

      // If the player does not exist in Hive, return an error message
      if (playerModel == null) {
        return 'Player not found in local storage.';
      }

      // Add the additional score to the current score
      playerModel.score += additionalScore;

      // Save the updated player data back to Hive
      await box.put(deviceId, playerModel);

      // Print the updated score for verification
      print(
          'Updated score for player ${playerModel.name}: ${playerModel.score}');

      return 'Player score updated successfully';
    } catch (e) {
      // If there's an error during updating data, handle it
      return 'Failed to update player score: $e';
    }
  }

  Future<void> _fetchWordMeaning(BuildContext context, String word) async {
    if (WordMeaningProvider.cachedMeaning != null) {
      DialogHelper.showValidationDialog(
        context,
        "Kahulugan",
        WordMeaningProvider.cachedMeaning!,
      );
      return;
    }
    const String apiKey = 'AIzaSyCGV6T533MWoTM0NxBBMfvj15_YzeKejVM';
    const String apiUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey";
    final Map<String, dynamic> payload = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Give a concise hint for the Tagalog term ${word}' that does not reveal the exact word, maintaining precise definition and must provide it in tagalog."
            }
          ]
        }
      ]
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        print('API Response: $responseData');
        if (responseData.containsKey('candidates') &&
            responseData['candidates'] is List &&
            (responseData['candidates'] as List).isNotEmpty) {
          final candidates = responseData['candidates'] as List;
          final dynamic content = candidates[0]['content'];
          if (content is Map && content.containsKey('parts')) {
            final List<dynamic> parts = content['parts'] as List<dynamic>;
            if (parts.isNotEmpty) {
              score -= 20;
              final String wordMeaning = parts[0]['text'] as String;
              String tagalogMeaning = wordMeaning;
              WordMeaningProvider.cachedMeaning = tagalogMeaning;
              DialogHelper.showValidationDialog(
                context,
                "Kahulugan",
                tagalogMeaning,
              );
            } else {
              DialogHelper.showValidationDialog(
                context,
                "Error",
                "Ang kahulugan ay walang tamang format. Subukan muli.",
              );
            }
          } else {
            DialogHelper.showValidationDialog(
              context,
              "Error",
              "Hindi nahanap ang parts na may text sa response. Subukan muli.",
            );
          }
        } else {
          DialogHelper.showValidationDialog(
            context,
            "Error",
            "Hindi nahanap ang kahulugan para sa salita. Response: $responseData",
          );
        }
      } else {
        DialogHelper.showValidationDialog(
          context,
          "Error",
          "Nabigo ang paghahanap ng kahulugan. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      DialogHelper.showValidationDialog(
        context,
        "Error",
        "May nangyaring error: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0), // Horizontal shake
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLetterRows(),
                  Gap(setResponsiveSize(context, baseSize: 20)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: setResponsiveSize(context, baseSize: 20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHintButton(),
                        Gap(setResponsiveSize(context, baseSize: 5)),
                        _buildMeaningButton(),
                      ],
                    ),
                  ),
                  Gap(setResponsiveSize(context, baseSize: 20)),
                  _buildKeyboard(),
                ],
              ),
              Positioned(
                top: setResponsiveSize(context, baseSize: 20),
                right: setResponsiveSize(context, baseSize: 20),
                child: Row(
                  children: [
                    Material(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: AppColor().darkGrey, width: 1),
                      ),
                      color: AppColor().white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: setResponsiveSize(context, baseSize: 8),
                            vertical: setResponsiveSize(context, baseSize: 5)),
                        child: Row(
                          children: [
                            Icon(Icons.timer,
                                color: AppColor().darkGrey, size: 20),
                            Gap(setResponsiveSize(context, baseSize: 5)),
                            CustFontstyle(
                              label: _formatTime(_start),
                              fontsize: 17,
                              fontweight: FontWeight.w500,
                              fontcolor: AppColor().darkGrey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(setResponsiveSize(context, baseSize: 10)),
                    InkWell(
                      onTap: () {
                        if (!_isPaused) {
                          _isPaused = true;
                          _timer?.cancel();
                          DialogHelper.showPauseOverDialog(context, randomWord,
                              () {
                            _isPaused = false;
                            _startTimer();
                          }, () {
                            WordMeaningProvider.cachedMeaning = null;
                            GoRouter.of(context)
                                .push('/play/session/${widget.letterCount}');
                          });
                        }
                      },
                      child: Material(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side:
                              BorderSide(color: AppColor().darkGrey, width: 1),
                        ),
                        color: AppColor().white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  setResponsiveSize(context, baseSize: 8),
                              vertical:
                                  setResponsiveSize(context, baseSize: 5)),
                          child: Icon(Icons.pause,
                              color: AppColor().darkGrey, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHintButton() {
    return InkWell(
      onTap: _useHint,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        color: AppColor().white,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: setResponsiveSize(context, baseSize: 10),
              horizontal: setResponsiveSize(context, baseSize: 10)),
          child: Row(
            children: [
              Icon(Icons.lightbulb, color: AppColor().warning),
              Gap(setResponsiveSize(context, baseSize: 5)),
              CustFontstyle(
                label: 'Tulong',
                fontsize: 17,
                fontweight: FontWeight.w500,
                fontcolor: AppColor().warning,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeaningButton() {
    return InkWell(
      onTap: () async {
        await _fetchWordMeaning(context, randomWord);
      },
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        color: AppColor().white,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: setResponsiveSize(context, baseSize: 10),
              horizontal: setResponsiveSize(context, baseSize: 10)),
          child: Row(
            children: [
              Icon(Icons.book, color: AppColor().valid),
              Gap(setResponsiveSize(context, baseSize: 5)),
              CustFontstyle(
                label: 'Kahulugan',
                fontsize: 17,
                fontweight: FontWeight.w500,
                fontcolor: AppColor().valid,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildLetterRows() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows
          .map((row) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((letter) => CustLetterbox(letter)).toList(),
              ))
          .toList(),
    );
  }

  Widget _buildKeyboard() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: setResponsiveSize(context, baseSize: 15)),
      child: Column(
        children: [
          _buildTopRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
          _buildMidRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
              isCentered: true),
          _buildBotKeyboardRow(),
        ],
      ),
    );
  }

  Widget _buildTopRow(List<String> keys, {bool isCentered = false}) {
    return Row(
      mainAxisAlignment: isCentered
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: keys.map((key) => _buildKeyboardKey(key)).toList(),
    );
  }

  Widget _buildMidRow(List<String> keys, {bool isCentered = false}) {
    return Row(
      mainAxisAlignment: isCentered
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: keys
          .map((key) => Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: setResponsiveSize(context, baseSize: 2),
                    vertical: setResponsiveSize(context, baseSize: 10)),
                child: _buildKeyboardKey(key),
              ))
          .toList(),
    );
  }

  Widget _buildBotKeyboardRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: _deleteLetter, child: _buildKeyboardButton(' ⌫ ', 15)),
        ...['Z', 'X', 'C', 'V', 'B', 'N', 'M']
            .map((key) => _buildKeyboardKey(key)),
        GestureDetector(
            onTap: _submitWord, child: _buildKeyboardButton('ENTER', 14)),
      ],
    );
  }

  Widget _buildKeyboardKey(String key) => GestureDetector(
      onTap: () => _addLetter(key), child: _buildKeyboardButton(key, 15));
  Widget _buildKeyboardButton(String label, double fontSize) {
    final keyColor =
        keyColors.containsKey(label) ? keyColors[label]! : AppColor().white;
    final fontColor =
        keyColor == AppColor().white ? AppColor().darklight : AppColor().white;
    return CustKeyboard(
      color: keyColor,
      children: CustFontstyle(
        label: label,
        fontweight: FontWeight.w800,
        fontsize: fontSize,
        fontcolor: fontColor,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }
}
