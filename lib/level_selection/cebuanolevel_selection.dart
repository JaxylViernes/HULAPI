import 'dart:io';

import 'package:basic/Components/cust_fontstyle.dart';
import 'package:basic/models/hiveAccount.dart';
import 'package:basic/models/playerData.dart';
import 'package:basic/utils/connectivity.dart';
import 'package:basic/utils/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
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

class CebuanoLevelSelectionScreen extends StatefulWidget with Application {
  final String playerId;
  final String language;
  const CebuanoLevelSelectionScreen(
      {super.key, required this.playerId, required this.language});

  @override
  State<CebuanoLevelSelectionScreen> createState() =>
      _CebuanoLevelSelectionScreenState();
}

class _CebuanoLevelSelectionScreenState
    extends State<CebuanoLevelSelectionScreen> with Application {
  int player_level = 0; // Initialize player level
  int player_score = 0; // Initialize player score
  String player_name = ''; // Initialize player name
  String player_avatar = ''; // Initialize player image
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch device ID
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    }
    throw UnsupportedError("Unsupported platform");
  }

  // Fetch player data stream from Firestore
  Stream<DocumentSnapshot> getPlayerDataStream(String deviceId) {
    return _firestore.collection('hulapi_player').doc(deviceId).snapshots();
  }

  // Check player data from Firestore or Hive
  void checkPlayerData() async {
    bool isConnected = await checkInternetConnection();
    String deviceId = await getDeviceId(); // Use the existing device ID logic

    if (isConnected) {
      getPlayerDataStream(deviceId).listen((snapshot) {
        if (snapshot.exists) {
          var playerData = snapshot.data() as Map<String, dynamic>;
          if (mounted) {
            // Check if the widget is still mounted
            setState(() {
              player_level = playerData['bisayaLevel'] as int;
              player_score = playerData['bisayaScore'] as int;
              player_name = playerData['name'] as String;
              player_avatar = playerData['image'] as String;
              print('Image: ${player_avatar}');
            });
          }
        } else {
          print("No player data found in Firestore.");
        }
      });
    } else {
      try {
        var box = await Hive.openBox<HiveAccount>('hulapi_player');
        if (box.isNotEmpty) {
          String deviceId = box.keys.first.toString();
          HiveAccount? player = box.get(deviceId); // Get the player object
          if (player != null && mounted) {
            // Check if the widget is still mounted
            setState(() {
              player_level =
                  player.bisayaLevel; // Use the level from Player data
              player_score = player.bisayaScore;
              player_name = player.name;
              player_avatar = player.avatar;
              print('Image: ${player_avatar}');
            });
          }
        }
      } catch (e) {
        print('Error fetching player data from Hive: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkPlayerData(); // Check player data when the screen loads
  }

  @override
  Widget build(BuildContext context) {
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
            top: setResponsiveSize(context, baseSize: 40),
            right: setResponsiveSize(context, baseSize: 0),
            left: setResponsiveSize(context, baseSize: 0),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: setResponsiveSize(context, baseSize: 8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    elevation: 2,
                    shape: const CircleBorder(
                        side: BorderSide(
                      color: Colors.white,
                      width: 3,
                    )),
                    child: Image.asset(
                      getAvatarPath(player_avatar),
                      height: setResponsiveSize(context, baseSize: 60),
                    ),
                  ),
                  Gap(setResponsiveSize(context, baseSize: 70)),
                  CustFontstyle(
                    label: player_name,
                    fontsize: setResponsiveSize(context, baseSize: 25),
                    fontcolor: AppColor().white,
                    fontweight: FontWeight.w600,
                  ),
                  Gap(setResponsiveSize(context, baseSize: 50)),
                  InkWell(
                    onTap: () {
                      print(widget.language);
                      GoRouter.of(context).go('/settings');
                    },
                    child: Icon(
                      Icons.settings,
                      color: color.white,
                      size: setResponsiveSize(context, baseSize: 28),
                    ),
                  ),
                  Gap(setResponsiveSize(context, baseSize: 10)),
                  InkWell(
                    onTap: () {
                      print(widget.language);
                      GoRouter.of(context).push('/leaderboards');
                    },
                    child: Icon(Icons.leaderboard_rounded,
                        color: color.white,
                        size: setResponsiveSize(context, baseSize: 28)),
                  ),
                  Gap(setResponsiveSize(context, baseSize: 10)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: setResponsiveSize(context, baseSize: 60),
            right: setResponsiveSize(context, baseSize: 0),
            left: setResponsiveSize(context, baseSize: 0),
            child: SingleChildScrollView(
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
                            horizontal:
                                setResponsiveSize(context, baseSize: 20),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                  color: player_level >= level.number - 1
                                      ? Colors.white
                                      : Colors.grey,
                                  width: 5),
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    setResponsiveSize(context, baseSize: 10),
                              ),
                              backgroundColor: player_level >= level.number - 1
                                  ? _getLevelColor(level
                                      .number) // Unique color for each level
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  setResponsiveSize(context, baseSize: 20),
                                ),
                              ), // Grey background for locked levels
                            ),
                            onPressed: player_level >= level.number - 1
                                ? () {
                                    final audioController =
                                        context.read<AudioController>();
                                    audioController.playSfx(SfxType.buttonTap);
                                    GoRouter.of(context)
                                        .go('/cebuano/session/${level.number}');
                                  }
                                : null,

                            // Disable button if level is locked
                            child: ListTile(
                              leading: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: setResponsiveSize(context,
                                        baseSize: 10)),
                                child: CustFontstyle(
                                  label:
                                      getDisplayNumber(level.number).toString(),
                                  fontcolor: AppColor().white,
                                  fontsize: 50,
                                  fontweight: FontWeight.w800,
                                ),
                              ),
                              title: CustFontstyle(
                                label: 'Hulaan ang salita na may',
                                fontcolor: AppColor().white,
                                fontsize: 12,
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
                                color: player_level >= level.number - 1
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
                                        player_level >= level.number - 1
                                            ? Icons
                                                .play_arrow_rounded // Open lock for unlocked levels
                                            : Icons.lock,
                                        size: 30, // Lock for locked levels
                                        color: player_level >= level.number - 1
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
                        const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 18),
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
          ),
        ],
      ),
    );
  }

  int getDisplayNumber(int levelNumber) {
    return levelNumber + 3;
  }

  String getAvatarPath(String playerAvatar) {
    return playerAvatar == 'assets\avatar\AVATAR1.png'
        ? 'assets/avatar/AVATAR1.png'
        : playerAvatar == 'assets\avatar\AVATAR2.png'
            ? 'assets/avatar/AVATAR2.png'
            : playerAvatar == 'assets\avatar\AVATAR3.png'
                ? 'assets/avatar/AVATAR3.png'
                : playerAvatar == 'assets\avatar\AVATAR4.png'
                    ? 'assets/avatar/AVATAR4.png'
                    : playerAvatar == 'assets\avatar\AVATAR5.png'
                        ? 'assets/avatar/AVATAR5.png'
                        : playerAvatar == 'assets\avatar\AVATAR6.png'
                            ? 'assets/avatar/AVATAR6.png'
                            : 'assets/avatar/AVATAR6.png';
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
