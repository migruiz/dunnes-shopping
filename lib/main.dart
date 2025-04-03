import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ShoppingList/ShoppingListWidget.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  KeepScreenOn.turnOn();
  runApp(const MaterialApp(title: 'Mobile Scanner Example', home: MyHome()));
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dunnes')),
      body: ShoppingListWidget(),
    );
  }
}
