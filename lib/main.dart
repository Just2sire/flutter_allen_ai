import 'package:allen_ai/colors.dart';
import 'package:allen_ai/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.whiteColor
        )
      ),
      home: const HomeScreen(),
    );
  }
}
