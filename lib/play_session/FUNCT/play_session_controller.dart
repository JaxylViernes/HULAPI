import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaySessionController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String playerName = '';
  String avatarUrl = '';
  int playerScore = 0;

  // Use this method to fetch player data by player ID
  Future<void> fetchPlayerData(String playerId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('PlayerId').doc(playerId).get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        playerName = data['name'].toString();
        avatarUrl = data['avatar'].toString();
        playerScore = int.parse(data['score'].toString());
        print(
            "Player Name: $playerName, Avatar URL: $avatarUrl, Score: $playerScore");
        notifyListeners();
      } else {
        print("No player data found for ID: $playerId");
      }
    } catch (error) {
      print("Failed to fetch data: $error");
    }
  }

  // Example validation method (implement as needed)
  bool validateName(BuildContext context) {
    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Player name cannot be empty")));
      return false;
    }
    return true;
  }
}
