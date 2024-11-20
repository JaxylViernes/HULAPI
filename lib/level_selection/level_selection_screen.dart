import 'package:basic/Components/cust_fontstyle.dart';
import 'package:basic/utils/responsive.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImage().LEVEL,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            bottom: setResponsiveSize(context, baseSize: 60),
            right: setResponsiveSize(context, baseSize: 0),
            left: setResponsiveSize(context, baseSize: 0),
            child: Column(
              children: [
                ListView(
                  shrinkWrap:
                      true, // Ensures the ListView only takes up as much space as its content
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    for (final level in gameLevels)
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: setResponsiveSize(context, baseSize: 5),
                          horizontal: setResponsiveSize(context, baseSize: 20),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                color: playerProgress.highestLevelReached >=
                                        level.number - 1
                                    ? Colors.white
                                    : Colors.grey,
                                width: 5),
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  setResponsiveSize(context, baseSize: 10),
                            ),
                            backgroundColor: playerProgress
                                        .highestLevelReached >=
                                    level.number - 1
                                ? _getLevelColor(
                                    level.number) // Unique color for each level
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                setResponsiveSize(context, baseSize: 20),
                              ),
                            ), // Grey background for locked levels
                          ),
                          onPressed: playerProgress.highestLevelReached >=
                                  level.number - 1
                              ? () {
                                  final audioController =
                                      context.read<AudioController>();
                                  audioController.playSfx(SfxType.buttonTap);
                                  GoRouter.of(context)
                                      .go('/play/session/${level.number}');
                                }
                              : null, // Disable button if level is locked
                          child: ListTile(
                            leading: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      setResponsiveSize(context, baseSize: 10)),
                              child: CustFontstyle(
                                label:
                                    getDisplayNumber(level.number).toString(),
                                fontcolor: AppColor().white,
                                fontsize: 60,
                                fontweight: FontWeight.w800,
                              ),
                            ),
                            title: CustFontstyle(
                              label: 'Hulaan ang salita na may',
                              fontcolor: AppColor().white,
                              fontsize: 15,
                              fontweight: FontWeight.w500,
                            ),
                            subtitle: CustFontstyle(
                              label: getDisplayText(level.number).toString(),
                              fontcolor: AppColor().white,
                              fontsize: 20,
                              fontweight: FontWeight.w700,
                            ),
                            trailing: Material(
                              borderRadius: BorderRadius.circular(25),
                              color: playerProgress.highestLevelReached >=
                                      level.number - 1
                                  ? Colors.white
                                  : Colors.white,
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Material(
                                  borderRadius: BorderRadius.circular(50),
                                  color: color.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      playerProgress.highestLevelReached >=
                                              level.number - 1
                                          ? Icons
                                              .play_arrow_rounded // Open lock for unlocked levels
                                          : Icons.lock,
                                      size: 30, // Lock for locked levels
                                      color: playerProgress
                                                  .highestLevelReached >=
                                              level.number - 1
                                          ? color.darkGrey
                                          : color
                                              .darkGrey, // Green for unlocked, white for locked
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/main');
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    ),
                    elevation: WidgetStateProperty.all<double>(4),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColor().yellow),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        side: BorderSide(color: AppColor().white, width: 4),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  child: CustFontstyle(
                    label: 'Bumalik',
                    fontsize: 25,
                    fontcolor: AppColor().black,
                    fontweight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int getDisplayNumber(int levelNumber) {
    return levelNumber + 3;
  }

  String getDisplayText(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return 'apat na titik';
      case 2:
        return 'lima na titik';
      case 3:
        return 'anim na titik';
      case 4:
        return 'pito na titik';
      default:
        return '';
    }
  }

  // Function to return a unique color for each level
  Color _getLevelColor(int levelNumber) {
    // Example color logic: Generate a color based on the level number
    switch (levelNumber % 5) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
