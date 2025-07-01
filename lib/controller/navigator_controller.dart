import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_pro/bloc/navigation/nav_bloc.dart';
import 'package:map_pro/bloc/navigation/nav_event.dart';

class NavigatorController {
  final BuildContext context;

  NavigatorController(this.context);

  void navigationOnTap(int currentIndex)
  {


    context.read<NavigationBloc>().add(NavigationItemSelected(currentIndex));


  }
}
