import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/app_sessions.dart';

class HiveService {
  var _noteBox = Hive.box(AppSessions.noteBox);

  Future<void> addNote({
    required String title,
    required String description,
    required String date,
    required int colorindex,
    required bool bookmarked,
  }) async {
    try {
      await _noteBox.add({
        "title": title,
        "description": description,
        "date": date,
        "colorIndex": colorindex,
        "bookmarked": bookmarked,
      });
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to add note !");
    }
  }

  Future<void> editNote({
    required int index,
    required String title,
    required String description,
    required String date,
    required int colorindex,
    required bool bookmarked,
  }) async {
    try {
      await _noteBox.put(index, {
        "title": title,
        "description": description,
        "date": date,
        "colorIndex": colorindex,
        "bookmarked": bookmarked,
      });
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to edit note !");
    }
  }

  List<dynamic> getNoteKeys() {
    try {
      final keys = _noteBox.keys.toList();
      List<dynamic> noteKeys = [];
      for (int i = 0; i < keys.length; i++) {
        if (keys[i]["bookmarked"] == false) {
          noteKeys.add(keys[i]);
        }
      }
      if (keys.isEmpty) return [];
      noteKeys.reversed;
      return noteKeys;
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to fetch data !");
    }
  }

  Future<void> onBookmark(int index, {required bool bookmarkValue}) async {
    try {
      final currentnote = _noteBox.get(index);
      await _noteBox.put(index, {
        "title": currentnote["title"],
        "description": currentnote["description"],
        "date": currentnote["date"],
        "colorIndex": currentnote["colorindex"],
        "bookmarked": bookmarkValue,
      });
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to save note !");
    }
  }

  List<dynamic> getBookmarkedKeys() {
    try {
      final keys = _noteBox.keys.toList();
      List<dynamic> bookmarkedKeys = [];
      for (int i = 0; i < keys.length; i++) {
        if (keys[i]["bookmarked"] == true) {
          bookmarkedKeys.add(keys[i]);
        }
      }
      if (bookmarkedKeys.isEmpty) {
        return [];
      } else {
        bookmarkedKeys.reversed;
        return bookmarkedKeys;
      }
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to fetch bookmarked data !");
    }
  }

  Map<dynamic, dynamic> getCurrentNote(int index) {
    try {
      final note = _noteBox.get(index);
      if (note == null) return {};
      return note;
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to fetch current note !");
    }
  }

  Future<void> removeAllNotes(List<dynamic> keys) async {
    try {
      await _noteBox.deleteAll(keys);
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to remove all notes !");
    }
  }

  Future<void> removeNote(int index) async {
    try {
      await _noteBox.delete(index);
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to remove note !");
    }
  }
}
