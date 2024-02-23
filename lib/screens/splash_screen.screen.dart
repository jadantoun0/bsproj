import 'package:deafconnect/nav.dart';
import 'package:deafconnect/providers/shortcuts.provider.dart';
import 'package:deafconnect/providers/transcript.provider.dart';
import 'package:deafconnect/utils/colors.dart';
import 'package:deafconnect/utils/navigation_utils.dart';
import 'package:deafconnect/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    bool isFirstTime =
        await SharedPreferencesUtils.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      print('isFirstTime');
      await SharedPreferencesUtils.setBool('isFirstTime', false);
    }

    if (mounted) {
      TranscriptProvider transcriptProvider =
          Provider.of<TranscriptProvider>(context, listen: false);
      if (isFirstTime) {
        await transcriptProvider.insertInitialTranscript();
      }
      await transcriptProvider.fetchTranscripts();
    }

    if (mounted) {
      ShortcutsProvider shortcutsProvider =
          Provider.of<ShortcutsProvider>(context, listen: false);
      if (isFirstTime) {
        await shortcutsProvider.insertInitialShortcuts();
      }
      await shortcutsProvider.fetchShortcuts();
    }

    if (mounted) {
      NavigationUtils.pushReplacement(context, const NavScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo/logo.png', width: 200),
              const Text(
                'DeafConnect',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
