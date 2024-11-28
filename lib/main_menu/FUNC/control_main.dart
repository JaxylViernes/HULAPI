import 'dart:io';

import 'package:basic/models/hiveAccount.dart';
import 'package:basic/models/playerData.dart';
import 'package:basic/utils/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class MainController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Declare a variable to store the player's level
  int player_lvl = 0;
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

  Future<void> checkPlayerData(BuildContext context) async {
    bool isConnected = await checkInternetConnection();
    String deviceId = await getDeviceId();

    if (deviceId.isEmpty) {
      print('Device ID cannot be empty');
      GoRouter.of(context).go('/playerSetup');
      return;
    }

    if (isConnected) {
      try {
        DocumentReference playerDoc =
            _firestore.collection('hulapi_player').doc(deviceId);
        DocumentSnapshot docSnapshot = await playerDoc.get();

        if (docSnapshot.exists) {
          var playerData =
              docSnapshot.data() as Map<String, dynamic>; // Cast to Map
          player_lvl = playerData['level'] as int;

          print(
              'Player data from Firestore: ${playerData['level']}, ${playerData['score']}');
          GoRouter.of(context).go('/play', extra: deviceId);
        } else {
          print("No player data found in Firestore.");
          GoRouter.of(context).go('/playerSetup');
        }
      } catch (e) {
        print('Error fetching player data from Firestore: $e');
        GoRouter.of(context).go('/playerSetup');
      }
    } else {
      try {
        var box = await Hive.openBox('hulapi_player');
        if (box.isNotEmpty) {
          var playerData = box.get(deviceId);

          if (playerData != null) {
            print(
                'Player data from Hive: ${playerData['name']}, ${playerData['level']}, ${playerData['score']}');
            GoRouter.of(context).go('/play', extra: deviceId);
          } else {
            print("No player data found in Hive.");
            GoRouter.of(context).go('/playerSetup');
          }
        } else {
          print("No player data found in Hive.");
          GoRouter.of(context).go('/playerSetup');
        }
      } catch (e) {
        print('Error fetching player data from Hive: $e');
        GoRouter.of(context).go('/playerSetup');
      }
    }
  }
}
