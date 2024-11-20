// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/Screens/playerSetup_screen.dart';
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
          path: 'play',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: const ValueKey('play'),
            color: context.watch<Palette>().backgroundLevelSelection,
            child: const LevelSelectionScreen(
              key: Key('level selection'),
              playerId: '',
            ),
          ),
          routes: [
            GoRoute(
              path: 'session/:level',
              pageBuilder: (context, state) {
                final levelNumber = int.parse(state.pathParameters['level']!);
                final level =
                    gameLevels.singleWhere((e) => e.number == levelNumber);

                final playerId = state.extra as String? ??
                    ''; // Ensure playerId is passed or set to default

                return buildMyTransition<void>(
                  key: ValueKey('session'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: PlaySessionScreen(
                    level,
                    playerId,
                    key: const Key('play session'),
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
