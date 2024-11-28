import 'dart:async';
import 'package:basic/Components/cust_fontstyle.dart';
import 'package:basic/game_internals/level_state.dart';
import 'package:basic/play_session/game_widget.dart';
import '../Components/cust_drawer.dart';
import '../Components/cust_showdialog.dart';
import '../helpers/app_init.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/score.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import 'FUNCT/play_session_controller.dart';

class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;
  final String playerId;
  final String language;
  const PlaySessionScreen(this.level, this.playerId, this.language,
      {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');
  static const _celebrationDuration = Duration(milliseconds: 2000);
  static const _preCelebrationDuration = Duration(milliseconds: 500);
  bool _duringCelebration = false;
  late DateTime _startOfPlay;

  @override
  void initState() {
    super.initState();
    _startOfPlay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlaySessionController(dialect: widget.language),
      child: Consumer<PlaySessionController>(
        builder: (context, playSessionController, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 5,
              iconTheme: IconThemeData(color: AppColor().white),
              backgroundColor: playSessionController.showRedScreen
                  ? Colors.red
                  : widget.level.number == 1
                      ? Application().color.blue
                      : widget.level.number == 2
                          ? Application().color.valid
                          : widget.level.number == 3
                              ? Application().color.warning
                              : widget.level.number == 4
                                  ? Application().color.invalid
                                  : Application().color.invalid,
              title: CustFontstyle(
                label: 'ANTAS ${widget.level.number}',
                fontcolor: AppColor().white,
                fontsize: 17,
                fontweight: FontWeight.w500,
                fontspace: 2,
              ),
              centerTitle: true,
              actions: [
                InkWell(
                  onTap: () => GoRouter.of(context).push('/leaderboards'),
                  child: Icon(Icons.leaderboard_outlined),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () => ShowDialogHelper.showHowToPlay(context),
                    child: Icon(Icons.question_mark_rounded),
                  ),
                ),
                InkWell(
                  onTap: () => GoRouter.of(context).push('/settings'),
                  child: Icon(Icons.settings),
                ),
                const Gap(20),
              ],
            ),
            backgroundColor: AppColor().white,
            body: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: AnimatedOpacity(
                    opacity: 0.5,
                    duration: Duration(milliseconds: 500),
                    child: Image.asset(
                      widget.level.number == 1
                          ? Application().image.BACK1
                          : widget.level.number == 2
                              ? Application().image.BACK2
                              : widget.level.number == 3
                                  ? Application().image.BACK3
                                  : widget.level.number == 4
                                      ? Application().image.BACK4
                                      : Application().image.BACK4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GameWidget(
                  letterCount: widget.level.number,
                  language: widget.language,
                ),
                SizedBox.expand(
                  child: Visibility(
                    visible: _duringCelebration,
                    child: IgnorePointer(
                      child: Confetti(
                        isStopped: !_duringCelebration,
                      ),
                    ),
                  ),
                ),
                if (playSessionController.showRedScreen) // Red screen effect
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 0.8,
                            colors: [
                              Colors.transparent, // Center is transparent
                              Colors.red.withOpacity(
                                  0.7), // Red shadow on the corners
                            ],
                            stops: [0.2, 5],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _playerWon() async {
    _log.info('Level ${widget.level.number} won');

    // Update player's progress
    final score = Score(
      widget.level.number,
      widget.level.difficulty,
      DateTime.now().difference(_startOfPlay),
    );
    context.read<PlayerProgress>().setLevelReached(widget.level.number);

    // Add a pre-celebration delay
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    // Trigger celebration
    setState(() {
      _duringCelebration = true;
    });

    // Play victory sound
    context.read<AudioController>().playSfx(SfxType.congrats);

    // Wait for the celebration to complete
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    // Navigate to the "win" screen
    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}
