import 'package:basic/Components/cust_fontstyle.dart';
import 'package:basic/helpers/app_init.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../Components/cust_alertdialog.dart';
import '../player_progress/player_progress.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

class SettingsScreen extends StatefulWidget with Application {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with Application {
  bool isMusic = false;
  bool isSound = false;
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor().white),
        backgroundColor: Colors.blueGrey,
        title: CustFontstyle(
          label: 'SETTING',
          fontsize: 17,
          fontcolor: AppColor().white,
          fontweight: FontWeight.w500,
          fontspace: 2,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColor().white,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Gap(50),
            Row(
              children: [
                CustFontstyle(
                  label: 'Player Name',
                  fontsize: 17,
                  fontcolor: AppColor().dark,
                  fontweight: FontWeight.w500,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => showCustomNameDialog(context),
                  icon: Icon(
                    Icons.forum_outlined,
                    color: AppColor().darkGrey,
                    size: 30,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                CustFontstyle(
                  label: 'Sound FX',
                  fontsize: 17,
                  fontcolor: AppColor().dark,
                  fontweight: FontWeight.w500,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isSound = !isSound;
                      settings.toggleSoundsOn();
                    });
                  },
                  icon: Icon(
                    isSound
                        ? Icons.volume_off_outlined
                        : Icons.volume_up_outlined,
                    color: AppColor().darkGrey,
                    size: 30,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                CustFontstyle(
                  label: 'Music FX',
                  fontsize: 17,
                  fontcolor: AppColor().dark,
                  fontweight: FontWeight.w500,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isMusic = !isMusic;
                      settings.toggleMusicOn();
                    });
                  },
                  icon: Icon(
                    isMusic
                        ? Icons.music_off_outlined
                        : Icons.music_note_outlined,
                    color: AppColor().darkGrey,
                    size: 30,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                CustFontstyle(
                  label: 'Reset',
                  fontsize: 17,
                  fontcolor: AppColor().dark,
                  fontweight: FontWeight.w500,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    DialogHelper.showResetDialog(context, 'Pag-reset ng Laro',
                        'Nais mo bang i-reset ang laro? Mawawala ang iyong progreso.',
                        () {
                      context.read<PlayerProgress>().reset();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(' Na-reset na ang laro. Simulan muli!'),
                      ));
                    });
                  },
                  icon: Icon(
                    Icons.restart_alt_outlined,
                    color: AppColor().darkGrey,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
