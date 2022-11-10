import 'package:flutter/material.dart';

import 'screens/account.dart';
import 'screens/home_page.dart';
import 'screens/report.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Report(),
      routes: {
        '/report': (context) => Report(),
        '/home': (context) => const HomePage(),
        '/account': (context) => const Account(),
      },
    );
  }
}
