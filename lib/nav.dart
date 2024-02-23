import 'package:deaf_connect/providers/store.provider.dart';
import 'package:deaf_connect/screens/chat.screen.dart';
import 'package:deaf_connect/screens/settings.screen.dart';
import 'package:deaf_connect/screens/sign_to_text.screen.dart';
import 'package:deaf_connect/screens/text_to_sign.screen.dart';
import 'package:deaf_connect/screens/transcripts.screen.dart';
import 'package:deaf_connect/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> screens = const [
    ChatScreen(),
    TranscriptsScreen(),
    TextToSignScreen(),
    SignToTextScreen(),
    SettingsScreen()
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (context, storeProvider, child) {
        return Scaffold(
          backgroundColor: secondaryColor,
          body: PageStorage(
            bucket: bucket,
            child: screens[storeProvider.selectedTab],
          ),
          bottomNavigationBar: BottomAppBar(
            surfaceTintColor: Colors.white,
            shape: const CircularNotchedRectangle(),
            padding: EdgeInsets.zero,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMaterialButton(
                  index: 0,
                  label: "Chat",
                  iconName: 'chat.svg',
                ),
                _buildMaterialButton(
                  index: 1,
                  label: "Transcripts",
                  iconName: 'transcripts.svg',
                ),
                _buildMaterialButton(
                  index: 2,
                  label: "Text to Sign",
                  iconName: 'sign.svg',
                ),
                _buildMaterialButton(
                  index: 3,
                  label: "Sign to Text",
                  iconName: 'camera.svg',
                ),
                _buildMaterialButton(
                  index: 4,
                  label: "Settings",
                  iconName: 'settings.svg',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaterialButton({
    required String label,
    required String iconName,
    required int index,
  }) {
    return Consumer<StoreProvider>(
      builder: (context, storeProvider, child) {
        return SizedBox(
          width: 70,
          child: MaterialButton(
            padding: EdgeInsets.zero,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                storeProvider.updateSelectedTab(index);
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/navbar/$iconName',
                  width: 30,
                  colorFilter: storeProvider.selectedTab == index
                      ? const ColorFilter.mode(mainColor, BlendMode.srcIn)
                      : const ColorFilter.mode(blackColor, BlendMode.srcIn),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: storeProvider.selectedTab == index
                        ? mainColor
                        : blackColor,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
