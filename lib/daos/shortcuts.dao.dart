import 'package:deaf_connect/database/db_helper.dart';
import 'package:deaf_connect/models/shortcut.model.dart';
import 'package:sqflite/sqflite.dart';

class ShortcutDAO {
  static Future<void> insertShortcut(Shortcut shortcut) async {
    final db = await DbHelper.getDb();
    await db.insert(
      'shortcuts',
      shortcut.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Shortcut>> getAllShortcuts() async {
    final db = await DbHelper.getDb();
    final List<Map<String, dynamic>> maps =
        await db.query('shortcuts', orderBy: 'shortcut_order');
    return List.generate(maps.length, (i) {
      return Shortcut.fromJson(maps[i]);
    });
  }

  static Future<void> updateShortcut(Shortcut shortcut) async {
    final db = await DbHelper.getDb();
    await db.update(
      'shortcuts',
      shortcut.toJson(),
      where: 'shortcut_order = ?',
      whereArgs: [shortcut.shortcutOrder],
    );
  }

  static Future<void> deleteShortcut(int shortcutOrder) async {
    final db = await DbHelper.getDb();
    await db.delete(
      'shortcuts',
      where: 'shortcut_order = ?',
      whereArgs: [shortcutOrder],
    );
  }

  static Future<void> deleteAllShortcuts() async {
    final db = await DbHelper.getDb();
    await db.delete('shortcuts');
  }
}
