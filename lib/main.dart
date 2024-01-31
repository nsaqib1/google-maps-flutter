import 'package:flutter/material.dart';
import 'package:google_maps_project/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Project',
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const HomeScreen(),
    );
  }
}
