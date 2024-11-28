import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class PlaySessionController extends ChangeNotifier {
  final String dialect;

  PlaySessionController({required this.dialect});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String playerName = '';
  String avatarUrl = '';
  int playerScore = 0;

  bool _showRedScreen = false;
  bool get showRedScreen => _showRedScreen;

  void toggleRedScreen() {
    _showRedScreen = !_showRedScreen;
    notifyListeners();
  }

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

  Future<void> updateScoreAndLevel(
      int score, int currentLevel, bool isLevelComplete) async {
    try {
      print("${dialect} this shit!");
      var connectivityResult = await Connectivity().checkConnectivity();
      String deviceId = await getDeviceId();

      if (deviceId.isEmpty) {
        throw Exception("Device ID cannot be empty");
      }

      int newLevel = currentLevel;

      if (connectivityResult != ConnectivityResult.none) {
        // Online: Retrieve the current level from Firestore
        DocumentReference playerDoc =
            _firestore.collection('hulapi_player').doc(deviceId);

        DocumentSnapshot docSnapshot = await playerDoc.get();
        if (docSnapshot.exists) {
          int existingLevel = 0;
          if (dialect == "Tagalog") {
            Map<String, dynamic> data =
                docSnapshot.data() as Map<String, dynamic>;
            int existingLevel = (data['tagalogLevel'] as int?) ?? 1;
          } else {
            Map<String, dynamic> data =
                docSnapshot.data() as Map<String, dynamic>;
            int existingLevel = (data['bisayaLevel'] as int?) ?? 1;
          }

          // Only update level if not already at the final level
          if (isLevelComplete) {
            newLevel = 4;
          } else {
            newLevel =
                existingLevel < currentLevel ? currentLevel : existingLevel;
          }

          if (dialect == "Tagalog") {
            await playerDoc
                .update({'tagalogScore': score, 'tagalogLevel': newLevel});
          } else {
            await playerDoc
                .update({'bisayaScore': score, 'bisayaLevel': newLevel});
          }
        } else {
          // If no document exists, create one
          newLevel = isLevelComplete ? 4 : currentLevel;
          await playerDoc.set({'score': score, 'level': newLevel});
        }
      } else {
        // Offline: Use Hive for local storage
        var box = await Hive.openBox('hulapi_player');
        Map<String, dynamic> playerData =
            (box.get(deviceId, defaultValue: {'score': 0, 'level': 1})
                as Map<String, dynamic>);

        int existingLevel = (playerData['level'] as int?) ?? 1;

        // Only update level if not already at the final level
        if (isLevelComplete) {
          newLevel = 4;
        } else {
          newLevel =
              existingLevel < currentLevel ? currentLevel : existingLevel;
        }
        if (dialect == "Tagalog") {
          await box
              .put(deviceId, {'tagalogScore': score, 'tagalogLevel': newLevel});
        } else {
          await box
              .put(deviceId, {'bisayaScore': score, 'bisayaLevel': newLevel});
        }
      }
    } catch (e) {
      debugPrint('Error updating score and level: $e');
    }
  }

  bool validateName(BuildContext context) {
    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Player name cannot be empty")),
      );
      return false;
    }
    return true;
  }
}
