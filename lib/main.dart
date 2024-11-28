// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:developer' as dev;
import 'package:basic/game_internals/level_state.dart';
import 'package:basic/models/hiveAccount.dart';
import 'package:basic/models/playerData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'helpers/hive_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'app_lifecycle/app_lifecycle.dart';
import 'audio/audio_controller.dart';
import 'player_progress/player_progress.dart';
import 'router.dart';
import 'settings/settings.dart';
import 'style/palette.dart';

Future<List<String>> loadWordsFromFile(String filePath) async {
  final wordData = await rootBundle.loadString('assets/words/$filePath');
  final words = wordData.split('\n');
  return words;
}

Future<void> initializeHive() async {
  await HiveHelper.init();
  if (HiveHelper.fourLetterWordsBox.isEmpty &&
      HiveHelper.fiveLetterWordsBox.isEmpty &&
      HiveHelper.sixLetterWordsBox.isEmpty &&
      HiveHelper.sevenLetterWordsBox.isEmpty &&
      HiveHelper.cebuanofourLetterWordsBox.isEmpty &&
      HiveHelper.cebuanofiveLetterWordsBox.isEmpty &&
      HiveHelper.cebuanosixLetterWordsBox.isEmpty &&
      HiveHelper.cebuanosevenLetterWordsBox.isEmpty) {
    final fourLetterWords = await loadWordsFromFile('4_letter_words.txt');
    await HiveHelper.fourLetterWordsBox.addAll(fourLetterWords);
    final fiveLetterWords = await loadWordsFromFile('5_letter_words.txt');
    await HiveHelper.fiveLetterWordsBox.addAll(fiveLetterWords);
    final sixLetterWords = await loadWordsFromFile('6_letter_words.txt');
    await HiveHelper.sixLetterWordsBox.addAll(sixLetterWords);
    final sevenLetterWords = await loadWordsFromFile('7_letter_words.txt');
    await HiveHelper.sevenLetterWordsBox.addAll(sevenLetterWords);

    final cebuanofourLetterWords =
        await loadWordsFromFile('cebuano_four_letter_words.txt');
    await HiveHelper.cebuanofourLetterWordsBox.addAll(cebuanofourLetterWords);
    final cebuanofiveLetterWords =
        await loadWordsFromFile('cebuano_five_letter_words.txt');
    await HiveHelper.cebuanofiveLetterWordsBox.addAll(cebuanofiveLetterWords);
    final cebuanosixLetterWords =
        await loadWordsFromFile('cebuano_six_letter_words.txt');
    await HiveHelper.cebuanosixLetterWordsBox.addAll(cebuanosixLetterWords);
    final cebuanosevenLetterWords =
        await loadWordsFromFile('cebuano_seven_letter_words.txt');
    await HiveHelper.cebuanosevenLetterWordsBox.addAll(cebuanosevenLetterWords);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    dev.log('Firebase initialization error: $e');
  }
  // Basic logging setup.
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
    );
  });
  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Lock the game to portrait mode on mobile devices.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Hive.registerAdapter(HiveAccountAdapter());
  Hive.registerAdapter(PlayerAdapter());

  await initializeHive();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        // This is where you add objects that you want to have available
        // throughout your game.
        //
        // Every widget in the game can access these objects by calling
        // `context.watch()` or `context.read()`.
        // See `lib/main_menu/main_menu_screen.dart` for example usage.
        providers: [
          Provider(create: (context) => SettingsController()),
          Provider(create: (context) => Palette()),
          ChangeNotifierProvider(create: (_) => LevelState(onWin: () {})),
          ChangeNotifierProvider(create: (_) => PlayerProgress()),
          // Set up audio.
          ProxyProvider2<AppLifecycleStateNotifier, SettingsController,
              AudioController>(
            create: (context) => AudioController(),
            update: (context, lifecycleNotifier, settings, audio) {
              audio!.attachDependencies(lifecycleNotifier, settings);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
            // Ensures that music starts immediately.
            lazy: false,
          ),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'My Flutter Game',
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.darkPen,
                // ignore: deprecated_member_use
                background: palette.backgroundMain,
              ),
              textTheme: TextTheme(
                bodyMedium: TextStyle(color: palette.ink),
              ),
              useMaterial3: true,
            ).copyWith(
              filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
          );
        }),
      ),
    );
  }
}
