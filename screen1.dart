import 'package:flutter/material.dart';
import 'package:untitled5/screen2.dart';
import 'setting.dart';

void main() {
  runApp(MenuApp());
}

class MenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu App',
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle new list button press
                print('New List button pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Screen2();
                    },
                  ),
                );
              },
              child: Text('New List'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle setting button press
                print('Setting button pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Settings();
                    },
                  ),
                );
              },
              child: Text('Setting'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle log out button press
                print('Log Out button pressed');
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}