import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Option 1'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Handle option 1 tap
              },
            ),
            ListTile(
              title: Text('Option 2'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Handle option 2 tap
              },
            ),
            // Add more settings options here
          ],
        ),
      ),
    );
  }
}