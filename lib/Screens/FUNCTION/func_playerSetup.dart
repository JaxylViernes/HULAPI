import 'package:basic/helpers/app_init.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

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

  Future<String?> savePlayerData() async {
    String playerName = nameController.text;
    String playerAvatar = avatarImages[selectedAvatarIndex];
    // Save data in Firestore
    try {
      DocumentReference docRef = await _firestore.collection('PlayerId').add({
        'name': playerName,
        'avatar': playerAvatar,
        'score': playerScore,
      });
      print("Player data saved successfully! Player ID: ${docRef.id}");
      return docRef.id; // Return the player ID
    } catch (error) {
      print("Failed to save data: $error");
      return null; // Return null if there was an error
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
