import 'package:flutter/material.dart';
import 'package:map_pro/controller/initial_controller.dart';
import 'package:map_pro/view/initial/splash_screen.dart';

class InitScreen extends StatelessWidget
{
  final InitController initController;

   const InitScreen({super.key, required this.initController});

  @override
  Widget build(BuildContext context)
  {
    Future.microtask(() => initController.handleRedirection(context));
    return SplashScreen();
  }
}
