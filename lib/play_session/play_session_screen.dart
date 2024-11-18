import 'dart:async';
import 'package:basic/Components/cust_fontstyle.dart';
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
import 'game_widget.dart';

class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;
  final String playerId;

  const PlaySessionScreen(this.level, this.playerId, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen>
    with Application {
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller =
        Provider.of<PlaySessionController>(context, listen: false);

    controller.fetchPlayerData(
        widget.playerId); // here i want to passed the player id
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlaySessionController(),
      child: Consumer<PlaySessionController>(
        builder: (context, playSessionController, child) {
          return Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                },
              ),
              elevation: 0,
              iconTheme: IconThemeData(color: AppColor().white),
              backgroundColor: Colors.blueGrey,
              title: CustFontstyle(
                label: 'LEVEL ${widget.level.number}',
                fontcolor: AppColor().white,
                fontsize: 17,
                fontweight: FontWeight.w500,
                fontspace: 2,
              ),
              centerTitle: true,
              actions: [
                InkWell(
                  onTap: () => GoRouter.of(context).push('/settings'),
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
            drawer: CustomDrawer(
              avatarUrl: playSessionController.avatarUrl,
              onBackPressed: () {
                Navigator.pop(context);
              },
              onQuitPressed: () {
                Navigator.pop(context);
              },
              playerName: playSessionController.playerName,
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
                      AppImage().back,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GameWidget(letterCount: widget.level.number),
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
                // Display player information
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _playerWon() async {
    _log.info('Level ${widget.level.number} won');

    final score = Score(
      widget.level.number,
      widget.level.difficulty,
      DateTime.now().difference(_startOfPlay),
    );

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(widget.level.number);

    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}
