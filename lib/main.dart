import 'package:flutter/material.dart';
import 'barcode_scanner_simple.dart';
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

  Widget _buildItem(BuildContext context, String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => page,
              ),
            );
          },
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner Example')),
      body: Center(
        child: ListView(
          children: [
            _buildItem(
              context,
              'MobileScanner Simple',
              const ScanWidget(),
            ),
           
          ],
        ),
      ),
    );
  }
}