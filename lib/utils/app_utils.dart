import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();

class AppUtils {
  static Future<String> formatedDatePicker({
    required DateTime firstdate,
  }) async {
    var date = await showDatePicker(
      context: navState.currentContext!,
      firstDate: firstdate,
      lastDate: DateTime.now(),
    );
    return DateFormat('MMMEd').format(date!);
  }

  static Future<void> shareNote(Map<dynamic, dynamic> note) async {
    await Share.share(
        "${note["title"]}\n${note["description"]}\n${note["date"]}");
  }
}
