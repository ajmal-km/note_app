import 'package:flutter/material.dart';
import 'package:note_app/services/hive_service.dart';
import '../app/init_depenencies.dart';
import '../utils/color_constants.dart';

class HomeController with ChangeNotifier {
  final _hiveService = locator<HiveService>();

  List<Color> noteColors = [
    ColorConstants.blue,
    ColorConstants.coral,
    ColorConstants.lightred,
    ColorConstants.cyanGreen,
    ColorConstants.darkCream,
  ];
  bool loading = false, isError = false, isSaved = false;
  String? message;
  List<dynamic> noteKeys = [];
  List<dynamic> bookmarkedKeys = [];
  int selectedColorIndex = 0;

  void setColorIndex(int index) {
    selectedColorIndex = index;
    notifyListeners();
  }

  void setBookmark() {
    isSaved = !isSaved;
    notifyListeners();
  }

  void resetColorIndex() {
    selectedColorIndex = 0;
    notifyListeners();
  }

  Future<void> addNote({
    required String title,
    required String description,
    required String date,
    required int colorIndex,
  }) async {
    try {
      loading = true;
      notifyListeners();
      await _hiveService.addNote(
        title: title,
        description: description,
        date: date,
        colorindex: colorIndex,
        bookmarked: isSaved,
      );
      getNotes();
    } on Exception catch (e) {
      isError = true;
      message = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> onNoteSaved(int index, {required bool isSaved}) async {}

  Map<dynamic, dynamic> getCurrentNote(int index) {
    try {
      return _hiveService.getCurrentNote(index);
    } on Exception catch (e) {
      isError = true;
      message = e.toString();
      loading = false;
      notifyListeners();
      return {};
    }
  }

  void getNotes() {
    try {
      loading = true;
      notifyListeners();
      noteKeys = _hiveService.getNoteKeys();
      isError = false;
      isSaved = false;
      message = null;
      loading = false;
      notifyListeners();
    } on Exception catch (e) {
      isError = true;
      message = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  void getBookmarkedNotes() {
    try {
      loading = true;
      notifyListeners();
      bookmarkedKeys = _hiveService.getBookmarkedKeys();
      isError = false;
      message = null;
      loading = false;
      notifyListeners();
    } on Exception catch (e) {
      isError = true;
      message = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> editNote({
    required int index,
    required String title,
    required String description,
    required String date,
    required int colorIndex,
  }) async {
    try {
      loading = true;
      notifyListeners();
      await _hiveService.editNote(
        index: noteKeys[index],
        title: title,
        description: description,
        date: date,
        colorindex: colorIndex,
        bookmarked: isSaved,
      );
      getNotes();
    } on Exception catch (e) {
      isError = true;
      message = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> removeAllNotes() async {
    try {
      loading = true;
      notifyListeners();
      await _hiveService.removeAllNotes(noteKeys);
      getNotes();
    } on Exception catch (e) {
      isError = true;
      message = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> removeNote(int index) async {
    try {
      loading = true;
      notifyListeners();
      await _hiveService.removeNote(noteKeys[index]);
      getNotes();
    } on Exception catch (e) {
      isError = true;
      message = e.toString();
      loading = false;
      notifyListeners();
    }
  }
}
