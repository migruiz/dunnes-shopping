import 'package:flutter/material.dart';
import 'ScanWidget.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KeepScreenOn.turnOn();
  runApp(
    const MaterialApp(
      title: 'Mobile Scanner Example',
      home: MyHome(),
    ),
  );
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dunnes')),
      body: ScanWidget(),
    );
  }
}