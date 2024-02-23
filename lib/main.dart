import 'package:deaf_connect/providers/shortcuts.provider.dart';
import 'package:deaf_connect/providers/store.provider.dart';
import 'package:deaf_connect/providers/transcript.provider.dart';
import 'package:deaf_connect/screens/splash_screen.screen.dart';
import 'package:deaf_connect/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TranscriptProvider()),
    ChangeNotifierProvider(create: (_) => StoreProvider()),
    ChangeNotifierProvider(create: (_) => ShortcutsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeafConnect',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: mainColor,
          foregroundColor: whiteColor,
          centerTitle: true,
          toolbarHeight: 65,
          titleTextStyle: TextStyle(
            fontSize: 19,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
            bodySmall: TextStyle(
              letterSpacing: 0.1,
            ),
            bodyMedium: TextStyle(
              letterSpacing: 0.1,
            ),
            bodyLarge: TextStyle(
              letterSpacing: 0.1,
            )),
      ),
      home: const SplashScreen(),
    );
  }
}
