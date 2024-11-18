import '../helpers/app_init.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/responsive_screen.dart';
import 'levels.dart';

class LevelSelectionScreen extends StatelessWidget with Application {
  final String playerId;

  const LevelSelectionScreen({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();

    // Sort the game levels by their number
    final sortedGameLevels = [...gameLevels]
      ..sort((a, b) => a.number.compareTo(b.number));

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImage().back,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          ResponsiveScreen(
            squarishMainArea: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Pumili ng Antas',
                      style: GoogleFonts.montserrat(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: ListView(
                    children: [
                      for (final level in sortedGameLevels)
                        ListTile(
                          onTap: () {
                            final audioController =
                                context.read<AudioController>();
                            audioController.playSfx(SfxType.buttonTap);

                            GoRouter.of(context)
                                .go('/play/session/${level.number}');
                          },
                          leading: Text(
                            level.number.toString(),
                            style: GoogleFonts.montserrat(),
                          ),
                          title: Text(
                            'Level #${level.number}',
                            style: GoogleFonts.montserrat(),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
            rectangularMenuArea: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/');
              },
              style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  backgroundColor: WidgetStateProperty.all(Colors.blueGrey)),
              child: Text('Bumalik',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
