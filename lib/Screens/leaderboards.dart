import 'dart:io';
import 'package:basic/Components/cust_fontstyle.dart';
import 'package:basic/helpers/app_init.dart';
import 'package:basic/models/hiveAccount.dart';
import 'package:basic/utils/responsive.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox<HiveAccount>(
      'players'); // Open Hive box to store player data

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaderboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LeaderboardScreen(),
    );
  }
}

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with Application {
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

  final CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('hulapi_player');

  // Function to push player data from Hive to Firestore
  Future<void> pushPlayerDataToFirebase(String deviceId) async {
    var box = await Hive.openBox<HiveAccount>('players');
    var playerModel = box.get(deviceId);

    if (playerModel != null) {
      await playersCollection.doc(deviceId).set(
        {
          'name': playerModel.name,
          'image': playerModel.avatar,
          'tagalogScore': playerModel.tagalogScore,
          'bisayaScore': playerModel.bisayaScore,
        },
        SetOptions(merge: true),
      );
      print('Player data updated in Firestore');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAndPushPlayerData();
  }

  Future<void> _loadAndPushPlayerData() async {
    String deviceId = await getDeviceId();
    await pushPlayerDataToFirebase(deviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: setResponsiveSize(context, baseSize: 70),
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: color.white,
          ),
          onTap: () {
            GoRouter.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: color.blue,
        title: CustFontstyle(
          label: 'Talaan',
          fontsize: setResponsiveSize(context, baseSize: 20),
          fontcolor: color.white,
          fontweight: FontWeight.w500,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: playersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No players found.'));
          }

          final players = snapshot.data!.docs;

          List<Map<String, dynamic>> playerDataList = players.map((player) {
            final playerName = player['name'] ?? 'Unknown';
            final playerImage = player['image'] ?? '';
            final bisayaScore = player['bisayaScore'] ?? 0;
            final tagalogScore = player['tagalogScore'] ?? 0;
            final totalScore = bisayaScore + tagalogScore;

            return {
              'player': player,
              'totalScore': totalScore,
              'playerName': playerName,
              'playerImage': playerImage,
              'bisayaScore': bisayaScore,
              'tagalogScore': tagalogScore,
            };
          }).toList();

          playerDataList.sort((a, b) =>
              (b['totalScore'] as num).compareTo(a['totalScore'] as num));

          return Stack(
            children: [
              Image.asset(
                AppImage().BACK1,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Column(
                children: [
                  Image.asset(
                    AppImage().TROPE,
                    fit: BoxFit.cover,
                    width: 300,
                    height: 300,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: playerDataList.length,
                      itemBuilder: (context, index) {
                        final playerData = playerDataList[index];
                        final playerName = playerData['playerName'];
                        final playerImage = playerData['playerImage'];
                        final bisayaScore = playerData['bisayaScore'];
                        final tagalogScore = playerData['tagalogScore'];
                        final totalScore = playerData['totalScore'];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white60,
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      setResponsiveSize(context, baseSize: 5)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      setResponsiveSize(context, baseSize: 15),
                                  vertical:
                                      setResponsiveSize(context, baseSize: 8),
                                ),
                                leading: CustFontstyle(
                                  label:
                                      '   ${index + 1}', // Display rank starting from 1
                                  fontsize: 25,
                                  fontweight: FontWeight.w800,
                                ),
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: setResponsiveSize(context,
                                          baseSize: 30),
                                      backgroundImage: (playerImage is String &&
                                              playerImage.isNotEmpty)
                                          ? AssetImage(
                                              getAvatarPath(playerImage))
                                          : AssetImage(
                                              'assets/avatar/default_avatar.png'),
                                    ),
                                    Gap(setResponsiveSize(context,
                                        baseSize: 10)),
                                    CustFontstyle(
                                      label: playerName.toString(),
                                      fontsize: 18,
                                      fontweight: FontWeight.w500,
                                      fontcolor: color.dark,
                                    ),
                                  ],
                                ),
                                trailing: CustFontstyle(
                                  label: '${totalScore.toString()} points',
                                  fontsize: 15,
                                  fontweight: FontWeight.w400,
                                  fontcolor: color.dark,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String getAvatarPath(String playerAvatar) {
    if (playerAvatar == 'assets/avatar/AVATAR1.png') {
      return 'assets/avatar/AVATAR1.png';
    } else if (playerAvatar == 'assets/avatar/AVATAR2.png') {
      return 'assets/avatar/AVATAR2.png';
    } else if (playerAvatar == 'assets/avatar/AVATAR3.png') {
      return 'assets/avatar/AVATAR3.png';
    } else if (playerAvatar == 'assets/avatar/AVATAR4.png') {
      return 'assets/avatar/AVATAR4.png';
    } else if (playerAvatar == 'assets/avatar/AVATAR5.png') {
      return 'assets/avatar/AVATAR5.png';
    } else {
      return 'assets/avatar/AVATAR6.png';
    }
  }
}
