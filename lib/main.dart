import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/splash_screen/splash_screen.dart';
import 'controller/splash_controller.dart';
import 'controller/home_controller.dart';
import 'app/init_depenencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
