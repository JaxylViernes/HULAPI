import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String avatarUrl;
  final String playerName;
  final VoidCallback onBackPressed;
  final VoidCallback onQuitPressed;

  const CustomDrawer({
    super.key,
    required this.avatarUrl,
    required this.playerName,
    required this.onBackPressed,
    required this.onQuitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(avatarUrl),
                  radius: 40,
                ),
                SizedBox(height: 10),
                Text(
                  playerName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Back to Game'),
            onTap: onBackPressed,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Quit Game'),
            onTap: onQuitPressed,
          ),
        ],
      ),
    );
  }
}
