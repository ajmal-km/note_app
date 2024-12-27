import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/splash_controller.dart';
import '../../utils/color_constants.dart';
import '../home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<SplashController>().initTimer(HomeScreen.route());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainColor,
      body: Center(
        child: Text(
          "NOTE APP",
          style: TextStyle(
            color: ColorConstants.blue,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}
