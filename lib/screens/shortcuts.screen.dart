import 'package:deaf_connect/models/shortcut.model.dart';
import 'package:deaf_connect/providers/shortcuts.provider.dart';
import 'package:deaf_connect/utils/colors.dart';
import 'package:deaf_connect/widgets/common/inkwell_with_opacity.dart';
import 'package:deaf_connect/widgets/dialogs/shortcut_dialog.dart';
import 'package:deaf_connect/widgets/transcripts/shortcut_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShortcutsScreen extends StatelessWidget {
  const ShortcutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        floatingActionButton: InkwellWithOpacity(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return ShortcutDialog(
                  onPressed: (text) async {
                    ShortcutsProvider shortcutsProvider =
                        Provider.of<ShortcutsProvider>(context, listen: false);
                    await shortcutsProvider.addShortcut(
                      Shortcut(
                        shortcutOrder: 0,
                        shortcutName: text,
                      ),
                    );
                  },
                );
              },
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: mainColor,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 28,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Shortcuts'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 1, color: lightGray),
              Consumer<ShortcutsProvider>(
                builder: (context, shortcutsProvider, child) {
                  return ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (Shortcut shortcut in shortcutsProvider.shortcuts)
                        ShortcutBox(shortcut, key: ValueKey(shortcut))
                    ],
                    onReorder: (oldIndex, newIndex) {
                      // if moving item down
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }

                      List<Shortcut> clonedList = shortcutsProvider.shortcuts;
                      Shortcut shortcut = clonedList.removeAt(oldIndex);
                      clonedList.insert(newIndex, shortcut);
                      shortcutsProvider.updateShortcuts(clonedList);

                      // store the changes in the db
                      shortcutsProvider.changeOrderInDB(clonedList);
                    },
                  );
                },
              ),
            ],
          ),
        ));
  }
}
