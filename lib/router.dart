import 'dart:developer';

import 'package:basic/Screens/categories.dart';
import 'package:basic/Screens/leaderboards.dart';
import 'package:basic/Screens/playerSetup_screen.dart';
import 'package:basic/level_selection/cebuanolevel_selection.dart';
import 'package:basic/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'game_internals/score.dart';
import 'level_selection/level_selection_screen.dart';
import 'level_selection/levels.dart';
import 'main_menu/main_menu_screen.dart';
import 'play_session/play_session_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'win_game/win_game_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
      routes: [
        GoRoute(
          path: 'main',
          builder: (context, state) =>
              const MainMenuScreen(key: Key('main menu')),
        ),
        GoRoute(
            path: 'categories',
            pageBuilder: (context, state) => buildMyTransition<void>(
                  key: const ValueKey('categories'),
                  color: context.watch<Palette>().backgroundLevelSelection,
                  child: const LanguageSelectionScreen(
                    key: Key('language selection'),
                  ),
                )),
        GoRoute(
            path: 'leaderboards',
            pageBuilder: (context, state) => buildMyTransition<void>(
                  key: const ValueKey('leaderboards'),
                  color: context.watch<Palette>().backgroundLevelSelection,
                  child: LeaderboardScreen(),
                )),
        GoRoute(
          path: 'play',
          pageBuilder: (context, state) {
            final language = state.extra as String? ??
                "Tagalog"; // Dynamically pass the language

            return buildMyTransition<void>(
              key: const ValueKey('play'),
              color: context.watch<Palette>().backgroundLevelSelection,
              child: LevelSelectionScreen(
                key: const Key('level selection'),
                playerId: '',
                language: language, // Pass the language dynamically
              ),
            );
          },
          routes: [
            GoRoute(
              path: 'session/:level',
              pageBuilder: (context, state) {
                final levelNumber = int.parse(state.pathParameters['level']!);
                final level =
                    gameLevels.singleWhere((e) => e.number == levelNumber);
                final language = state.extra as String? ??
                    "Tagalog"; // Dynamically pass the language

                log('LEVEL NUMBER: $levelNumber');

                final playerId = state.extra as String? ??
                    ''; // Ensure playerId is passed or set to default

                return buildMyTransition<void>(
                  key: ValueKey('Tagalog session_$levelNumber'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: PlaySessionScreen(
                    level,
                    playerId,
                    language,
                    key: Key('Tagalog play_session_$levelNumber'),
                  ),
                );
              },
            ),
            GoRoute(
              path: 'won',
              redirect: (context, state) => state.extra == null ? '/' : null,
              pageBuilder: (context, state) {
                final map = state.extra! as Map<String, dynamic>;
                final score = map['score'] as Score;

                return buildMyTransition<void>(
                  key: const ValueKey('won'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: WinGameScreen(
                    score: score,
                    key: const Key('win game'),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'cebuano',
          pageBuilder: (context, state) {
            const language = "Cebuano"; // Set the language as Cebuano here

            return buildMyTransition<void>(
              key: const ValueKey('cebuano'),
              color: context.watch<Palette>().backgroundLevelSelection,
              child: CebuanoLevelSelectionScreen(
                key: const Key('level selection'),
                playerId: '',
                language: language, // Pass Cebuano language here
              ),
            );
          },
          routes: [
            GoRoute(
              path: 'session/:level',
              pageBuilder: (context, state) {
                final levelNumber = int.parse(state.pathParameters['level']!);
                final level =
                    gameLevels.singleWhere((e) => e.number == levelNumber);
                const language = "Cebuano"; // Set the language as Cebuano

                final playerId = state.extra as String? ??
                    ''; // Ensure playerId is passed or set to default

                return buildMyTransition<void>(
                  key: ValueKey('Cebuano session_$levelNumber'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: PlaySessionScreen(
                    level,
                    playerId,
                    language,
                    key: Key('Cebuano play_session_$levelNumber'),
                  ),
                );
              },
            ),
            GoRoute(
              path: 'won',
              redirect: (context, state) => state.extra == null ? '/' : null,
              pageBuilder: (context, state) {
                final map = state.extra! as Map<String, dynamic>;
                final score = map['score'] as Score;

                return buildMyTransition<void>(
                  key: const ValueKey('won'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: WinGameScreen(
                    score: score,
                    key: const Key('win game'),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
        GoRoute(
          path: 'playerSetup',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: const ValueKey('playerSetup'),
            color: context.watch<Palette>().backgroundLevelSelection,
            child: const PlayersetupScreen(key: Key('playerSetup')),
          ),
        ),
      ],
    ),
  ],
);
