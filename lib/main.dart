import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/screens/first_screen.dart';
import 'package:application/providers/app_state_provider.dart';
import 'package:application/providers/palindrome_provider.dart';
import 'package:application/providers/user_data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => PalindromeProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ],
      child: MaterialApp(
        title: 'Application',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const FirstScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
