import 'package:basic/Components/cust_fontstyle.dart';
import 'package:basic/helpers/app_init.dart';
import 'package:basic/models/hiveAccount.dart';
import 'package:basic/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  Future<void> checkPlayerData(BuildContext context) async {
    var box = await Hive.openBox<HiveAccount>('players');

    // Check if the box is not empty and handle nullable account type properly
    if (box.isNotEmpty) {
      String playerId = box.keys.first.toString();

      // Using null-aware operator or checking for null before assignment
      HiveAccount? player = box.get(playerId);

      if (player != null) {
        print(
            'Player data from Hive: ${player.name}, ${player.avatar}, ${player.score}');
        GoRouter.of(context).go('/categories', extra: playerId);
      } else {
        // Handle case when player is null
        print("Player data is null in Hive!");
        GoRouter.of(context).go('/playerSetup');
      }
    } else {
      GoRouter.of(context).go('/playerSetup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImage().START,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            bottom: setResponsiveSize(context, baseSize: 100),
            right: setResponsiveSize(context, baseSize: 60),
            left: setResponsiveSize(context, baseSize: 60),
            child: ElevatedButton(
              onPressed: () {
                checkPlayerData(context);
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
                label: 'Maglaro na!',
                fontsize: 25,
                fontcolor: AppColor().black,
                fontweight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
