import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/services/hive_service.dart';
import 'package:note_app/utils/app_sessions.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHive();
  _initServices();
}

_initHive() async {
  await Hive.initFlutter();
  locator.registerLazySingleton(
      () async => await Hive.openBox(AppSessions.noteBox));
}

_initServices() {
  locator.registerLazySingleton<HiveService>(() => HiveService());
}
