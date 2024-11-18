import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/Mainback.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 470, left: 100),
            child: ElevatedButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/playerSetup');
              },
              style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 50)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  backgroundColor: WidgetStateProperty.all(Colors.blueGrey)),
              child: Text('Maglaro na!',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
