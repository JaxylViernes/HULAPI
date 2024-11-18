import 'dart:async';
import 'package:basic/helpers/app_init.dart';
import '../Components/cust_fontstyle.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/level_state.dart';
import '../helpers/hive_helper.dart';
import '../models/letter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Components/cust_keyboard.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../Components/cust_alertdialog.dart';
import '../Components/cust_letterbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordMeaningProvider {
  static String? cachedMeaning;
}

class GameWidget extends StatefulWidget {
  const GameWidget({super.key, required this.letterCount});
  final int letterCount;

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  late String randomWord;
  late List<List<Letter>> rows;
  late Box wordsBox;
  late int totalLetters;
  int currentCol = 0, currentRow = 0;
  bool isWordCorrect = false;
  Map<String, Color> keyColors = {};
  Timer? _timer;
  int _start = 180;
  bool hintUsed = false;
  String wordMeaning = '';

  @override
  void initState() {
    super.initState();
    totalLetters = 4 + widget.letterCount;
    wordsBox = _getWordsBox(totalLetters);
    randomWord = HiveHelper.randomWord(totalLetters, wordsBox).trim();
    rows = List.generate(
        6,
        (_) => List.generate(totalLetters,
            (_) => Letter(letter: "", color: const Color(0xffDBDBDB))));

    _startTimer();
  }

  void _useHint() {
    if (hintUsed) {
      DialogHelper.showValidationDialog(
          context, 'Hint Used', 'You can only use one hint per game.');
      return;
    }

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
      } else {
        _updateRow();
        currentCol = 0;
        currentRow++;
        if (isWordCorrect) {
          context.read<LevelState>().setProgress(100);
          context.read<AudioController>().playSfx(SfxType.wssh);
          context.read<LevelState>().evaluate();
        } else if (currentRow == 6 || _start == 0) {
          Future.delayed(Duration(milliseconds: 600), () {
            _timer?.cancel();
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
          _timer?.cancel();
          DialogHelper.showGameOverDialog(context, randomWord, () {
            GoRouter.of(context).push('/play/session/${widget.letterCount}');
          });
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
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

    final String apiKey = 'AIzaSyCGV6T533MWoTM0NxBBMfvj15_YzeKejVM';
    final String apiUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey";

    final Map<String, dynamic> payload = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "What is the meaning of this word $word? Explain it in Tagalog with just a short sentence without mentioning the actual word. Just hint"
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
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLetterRows(),
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHintButton(),
                const Gap(10),
                _buildMeaningButton(),
              ],
            ),
            const Gap(10),
            _buildKeyboard(),
          ],
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Material(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: AppColor().darkGrey, width: 1),
            ),
            color: AppColor().white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
                  Icon(Icons.timer, color: AppColor().darkGrey, size: 20),
                  const Gap(5),
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
        ),
      ],
    );
  }

  Widget _buildHintButton() {
    return ElevatedButton.icon(
      onPressed: _useHint,
      icon: const Icon(Icons.lightbulb, color: Colors.yellow),
      label: const Text('Tulong'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor().darkGrey,
        foregroundColor: AppColor().white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  Widget _buildMeaningButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        await _fetchWordMeaning(context, randomWord);
      },
      icon: const Icon(Icons.book, color: Colors.blue),
      label: const Text('Kahulugan'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor().darkGrey,
        foregroundColor: AppColor().white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
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
    super.dispose();
  }
}
