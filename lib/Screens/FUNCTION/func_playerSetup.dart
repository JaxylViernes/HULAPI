import 'dart:io';

import 'package:basic/helpers/app_init.dart';
import 'package:basic/models/hiveAccount.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class PlayerSetupViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final PageController pageController = PageController(viewportFraction: 0.3);
  int selectedAvatarIndex = 0;
  int playerScore = 0; // Default score, modify as needed

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  final List<String> avatarImages = [
    Application().avatar.avatar1,
    Application().avatar.avatar2,
    Application().avatar.avatar3,
    Application().avatar.avatar4,
    Application().avatar.avatar5,
    Application().avatar.avatar6,
  ];
  final OutlineInputBorder borderCust = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: AppColor().white, width: 1),
  );
  List<Color> listOfColors = const [
    Colors.green,
    Colors.yellow,
    Colors.green,
    Colors.yellow,
    Colors.green,
    Colors.yellow
  ];
  List<Color> listBackground = const [
    Color(0xFF88C273), // Medium Green
    Color(0xFFFFB38E), // Bright Yellow
    Color(0xFF789DBC), // Dark Green
    Color(0xFFE4C087), // Amber Yellow
    Color(0xFF697565), // Light Green
    Color(0xFFE6B9A6), // Light Yellow
  ];

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Android ID as device identifier
      print('Running on ${androidInfo.model}');
    }
    return deviceId;
  }

  Future<String?> savePlayerData() async {
    String playerName = nameController.text;
    String playerAvatar = avatarImages[selectedAvatarIndex];
    // Save data in Firestore
    try {
      // Get the device ID
      String deviceId = await getDeviceId();

      // Open the Hive box to store player data
      var box = await Hive.openBox<HiveAccount>('players');

      // Create a new player object with the given details
      var playerModel = HiveAccount(
        name: playerName,
        avatar: playerAvatar,
        score: 0,
      );

      // Store the player data using the device ID as key
      await box.put(deviceId, playerModel);

      print("Player score saved locally in Hive");

      return deviceId;
    } catch (error) {
      // Improved error handling
      print("Failed to save data: $error");
      throw Exception(
          "Error saving player score: $error"); // Throwing exception for better tracking
    }
  }

  // Function to call when the start button is pressed
  void startGame(BuildContext context) async {
    if (validateName(context)) {
      String? playerId =
          await savePlayerData(); // Save to Firestore and get player ID
      if (playerId != null) {
        print("Player passed the data successfully! Player ID: $playerId");
        // Pass the player ID to the PlaySessionController or next screen
        GoRouter.of(context).push('/play',
            extra: playerId); // Navigate to the play screen with player ID
      }
    }
  }

  void onPageChanged(double page) {
    int selectedIndex = page.round();
    if (selectedAvatarIndex != selectedIndex) {
      selectedAvatarIndex = selectedIndex;
      notifyListeners();
    }
  }

  bool validateName(BuildContext context) {
    if (nameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Name"),
          content: const Text("Player name cannot be empty."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    pageController.dispose();
    super.dispose();
  }
}
